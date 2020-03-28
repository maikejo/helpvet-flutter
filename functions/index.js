const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()

exports.sendNotification = functions.firestore
  .document('chat/{groupId1}/{groupId2}/{message}')
  .onCreate((snap, context) => {
    console.log('----------------start function--------------------')

    const doc = snap.data()
    console.log(doc)

    const idFrom = doc.senderUid
    const idTo = doc.receiverUid
    const contentMessage = doc.mensagem

    console.log(`ID QUEM ENVIO  ----- : ${idFrom}`)
    console.log(`ID QUEM RECEBE ----- : ${idTo}`)
    // Get push token user to (receive)
    admin
      .firestore()
      .collection('usuarios')
      .where('email', '==', idTo)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(userTo => {
          console.log(`Usuario encontrado ------- : ${userTo.data().nome}`)

          if (userTo.data().pushToken) {
            // Get info user from (sent)
            admin
              .firestore()
              .collection('usuarios')
              .where('email', '==', idFrom)
              .get()
              .then(querySnapshot2 => {
                querySnapshot2.forEach(userFrom => {
                  console.log(`Usuario de ENVIO :  ${userFrom.data().nome}`)
                  const payload = {
                    notification: {
                      title: `Mensagem de : ${userFrom.data().nome}`,
                      body: contentMessage,
                      badge: '1',
                      sound: 'default',
                      icon: 'default'
                    }
                  }

                  console.log(`TOKEN DE QUEM VAI RECEBER NOTIFICACAO ------- : ${userTo.data().pushToken}`)
                  // Let push to the target device
                  admin
                    .messaging()
                    .sendToDevice(userTo.data().pushToken, payload)
                    .then(response => {
                      console.log('MENSAGEM ENVIADA COM SUCESSO:', response)
                    })
                    .catch(error => {
                      console.log('Error sending message:', error)
                    })
                })
              })
          } else {
            console.log('Can not find pushToken target user')
          }
        })
      })
    return null
  })