import 'package:flutter/material.dart';

class TimelineData {
  final String name;
  final String time;
  final String content;
  final String doodle;
  final Color iconBackground;
  final Icon icon;
  const TimelineData(
      {this.name,
        this.time,
        this.content,
        this.doodle,
        this.icon,
        this.iconBackground});
}

const List<TimelineData> doodles = [
  TimelineData(
      name: "Cadastro Consulta",
      time: "23/10/19",
      content:
      "Averroes was an Andalusian philosopher and thinker who wrote about many subjects, including philosophy, theology, medicine, astronomy, physics, Islamic jurisprudence and law, and linguistics. His philosophical works include numerous commentaries on Aristotle, for which he was known in the West as The Commentator. He also served as a judge and a court physician for the Almohad Caliphate.",
      doodle:
      "https://firebasestorage.googleapis.com/v0/b/animal-home-care.appspot.com/o/maikejo%40gmail.com%2Fdocumentos%2Fvacinas%2Fvacina_26-09-2019?alt=media&token=4eaeb87e-92b5-4c29-b16e-e20e57488e57",
      icon: Icon(
        Icons.blur_circular,
        color: Colors.white,
      ),
      iconBackground: Colors.indigo),
  TimelineData(
      name: "Agendamento",
      time: "22/10/19",
      content:
      "Tusi was a Persian polymath, architect, philosopher, physician, scientist, and theologian. He is often considered the creator of trigonometry as a mathematical discipline in its own right. Ibn Khaldun (1332–1406) considered Al-Tusi to be the greatest of the later Persian scholars.",
      doodle:
      "https://firebasestorage.googleapis.com/v0/b/animal-home-care.appspot.com/o/maikejo%40gmail.com%2Fdocumentos%2Fvacinas%2Fvacina_26-09-2019?alt=media&token=4eaeb87e-92b5-4c29-b16e-e20e57488e57",
      icon: Icon(
        Icons.calendar_today,
        color: Colors.white,
      ),
      iconBackground: Colors.pinkAccent),
  TimelineData(
      name: "Ativação",
      time: "22/10/19",
      content:
      "Over a period of thirty years, Ibn Battuta visited most of the Islamic world and many non-Muslim lands, including North Africa, the Horn of Africa, West Africa, the Middle East, Central Asia, Southeast Asia, South Asia and China. Near the end of his life, he dictated an account of his journeys, titled A Gift to Those Who Contemplate the Wonders of Cities and the Marvels of Travelling (Tuḥfat an-Nuẓẓār fī Gharāʾib al-Amṣār wa ʿAjāʾib al-Asfār), usually simply referred to as The Travels (Rihla). This account of his journeys provides a picture of a medieval civilisation that is still widely consulted today.",
      doodle:
      "https://firebasestorage.googleapis.com/v0/b/animal-home-care.appspot.com/o/maikejo%40gmail.com%2Fdocumentos%2Fvacinas%2Fvacina_26-09-2019?alt=media&token=4eaeb87e-92b5-4c29-b16e-e20e57488e57",
      icon: Icon(
        Icons.add,
        color: Colors.white,
        size: 32.0,
      ),
      iconBackground: Colors.deepPurpleAccent),
  TimelineData(
      name: "Cadastro Exame",
      time: "21/10/19",
      content:
      "He is widely considered as a forerunner of the modern disciplines of historiography, sociology, economics, and demography.\nHe is best known for his book, the Muqaddimah or Prolegomena ('Introduction'). The book influenced 17th-century Ottoman historians like Kâtip Çelebi, Ahmed Cevdet Pasha and Mustafa Naima, who used the theories in the book to analyse the growth and decline of the Ottoman Empire. Also, 19th-century European scholars acknowledged the significance of the book and considered Ibn Khaldun to be one of the greatest philosophers of the Middle Ages.",
      doodle:
      "https://firebasestorage.googleapis.com/v0/b/animal-home-care.appspot.com/o/maikejo%40gmail.com%2Fdocumentos%2Fvacinas%2Fvacina_26-09-2019?alt=media&token=4eaeb87e-92b5-4c29-b16e-e20e57488e57",
      icon: Icon(
        Icons.archive,
        color: Colors.white,
      ),
      iconBackground: Colors.teal),
  TimelineData(
      name: "Cadastro Vacina",
      time: "20/10/19",
      content:
      "He is primarily known today for his maps and charts collected in his Kitab-ı Bahriye (Book of Navigation), a book that contains detailed information on navigation, as well as very accurate charts (for their time) describing the important ports and cities of the Mediterranean Sea. He gained fame as a cartographer when a small part of his first world map (prepared in 1513) was discovered in 1929 at the Topkapı Palace in Istanbul. His world map is the oldest known Turkish atlas showing the New World, and one of the oldest maps of America still in existence anywhere (the oldest known map of America that is still in existence is the map drawn by Juan de la Cosa in 1500). Piri Reis' map is centered on the Sahara at the latitude of the Tropic of Cancer.",
      doodle:
      "https://firebasestorage.googleapis.com/v0/b/animal-home-care.appspot.com/o/maikejo%40gmail.com%2Fdocumentos%2Fvacinas%2Fvacina_26-09-2019?alt=media&token=4eaeb87e-92b5-4c29-b16e-e20e57488e57",
      icon: Icon(
        Icons.add_to_queue,
        color: Colors.white,
        size: 32.0,
      ),
      iconBackground: Colors.blue),
];