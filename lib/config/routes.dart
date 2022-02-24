import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import '../screens/login_screen.dart';
import './route_handlers.dart';

class RouteConstants {
  static const String ROUTE_LOGIN = "/login";
  static const String ROUTE_SIGN_UP = "/sign_up";
  static const String ROUTE_FORGOT_PASSWORD = "/forgot_password";
  static const String ROUTE_VERIFY_CODE = "/verify_code";
  static const String ROUTE_CREATE_WALLET = "/create_wallet";
  static const String ROUTE_HOME = "/home";
  static const String ROUTE_LIST_WALLET = "/list_wallet";
  static const String ROUTE_INFORMATION = "/information";
  static const String ROUTE_PROFILE_GUEST = "/profile_guest";
  static const String ROUTE_PROFILE_LESS = "/profile_less";
  static const String ROUTE_PROFILE_MORE = "/profile_more";
  static const String ROUTE_PROFILE_PREMIUM = "/profile_premium";
  static const String ROUTE_REPORT = "/report";
  static const String ROUTE_SETTINGS_PROFILE = "/settings_profile";
  static const String ROUTE_ADD_TRANSACTION = "/add_transaction";
  static const String ROUTE_SPLASH = "/";
  static const String ROUTE_WALK_THROUGH = "/walk_through";
  static const String ROUTE_ADD_BANK = "/add_bank";
  static const String ROUTE_CHART = "/chart";
  static const String ROUTE_PREMIUM_ACCOUNT = "/premium_account";
  static const String ROUTE_ADD_WALLET = "/add_wallet";
  static const String ROUTE_CATEGORY = "/category";
  static const String ROUTE_ERROR = "/error";
  static const String ROUTE_CADASTRO_PET = "/cadastro_pet";
  static const String ROUTE_LOCALIZACAO_PET = "/localizacao_pet";
  static const String ROUTE_CHAT_USERS = "/chat_users";
  static const String ROUTE_VACINAS = "/vacinas";
  static const String ROUTE_EXAMES = "/exames";
  static const String ROUTE_CONSULTAS = "/consultas";
  static const String ROUTE_QR_CODE = "/qrCode";
  static const String ROUTE_AGENDA = "/agenda";
  static const String ROUTE_PLANOS = "/planos";
  static const String ROUTE_PAGAMENTO = "/pagamento";
  static const String ROUTE_TIMELINE = "/timeline";
  static const String ROUTE_TUTORIAL = "/tutorial";
  static const String ROUTE_COMPARTILHAR = "/compartilhar";
  static const String ROUTE_HOME_PET = "/homePet";
  static const String ROUTE_HOME_ADM = "/homeAdm";
  static const String ROUTE_LISTA_VET_ADM = "/listaVetAdm";
}

class Routes {
  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new LoginScreen();
    });

    router.define(RouteConstants.ROUTE_SPLASH, handler: splashHandler);
    router.define(RouteConstants.ROUTE_HOME, handler: homeHandler);
    router.define(RouteConstants.ROUTE_LOGIN, handler: loginHandler);
    router.define(RouteConstants.ROUTE_SIGN_UP, handler: signUpHandler);
    router.define(RouteConstants.ROUTE_FORGOT_PASSWORD, handler: forgotPasswordHandler);
    router.define(RouteConstants.ROUTE_VERIFY_CODE, handler: verifyCodeHandler);
    router.define(RouteConstants.ROUTE_PROFILE_GUEST, handler: profileGuestHandler);
    router.define(RouteConstants.ROUTE_PROFILE_MORE, handler: profileMoreHandler);
    router.define(RouteConstants.ROUTE_REPORT, handler: reportHandler);
    router.define(RouteConstants.ROUTE_WALK_THROUGH, handler: walkThroughHandler);
    router.define(RouteConstants.ROUTE_PREMIUM_ACCOUNT, handler: premiumAccountHandler);
    router.define(RouteConstants.ROUTE_HOME_ADM, handler: homeAdmHandler);
    router.define(RouteConstants.ROUTE_LISTA_VET_ADM, handler: listaVetAdmHandler);



    //Cadastro
    router.define(RouteConstants.ROUTE_CADASTRO_PET,
        handler: cadastroPetHandler);

    //Localizacao
  /*  router.define(RouteConstants.ROUTE_LOCALIZACAO_PET,
        handler: localizacaoPetHandler);*/

    //Chat
    router.define(RouteConstants.ROUTE_CHAT_USERS,
        handler: chatPetHandler);

    //Vacina
    router.define(RouteConstants.ROUTE_VACINAS,
        handler: vacinaHandler);

    //Exame
    router.define(RouteConstants.ROUTE_EXAMES,
        handler: exameHandler);

    //Consulta
    router.define(RouteConstants.ROUTE_CONSULTAS,
        handler: consultaHandler);

    //QRCODE
    router.define(RouteConstants.ROUTE_QR_CODE,
        handler: qrCodeHandler);

    //AGENDA
    router.define(RouteConstants.ROUTE_AGENDA,
        handler: agendaHandler);

    //PLANOS
    router.define(RouteConstants.ROUTE_PLANOS,
        handler: planosHandler);

    //PAGAMENTO
    router.define(RouteConstants.ROUTE_PAGAMENTO,
        handler: pagamentoHandler);

    //TIMELINE
    router.define(RouteConstants.ROUTE_TIMELINE,
        handler: timelineHandler);

    //TUTORIAL
    router.define(RouteConstants.ROUTE_TUTORIAL,
        handler: tutorialHandler);

    //COMPARTILHAR
    router.define(RouteConstants.ROUTE_COMPARTILHAR,
        handler: compartilharHandler);

    //COMPARTILHAR
    router.define(RouteConstants.ROUTE_HOME_PET,
        handler: homePetHandler);

    //HOME_ADM
    router.define(RouteConstants.ROUTE_HOME_ADM,
        handler: homePetHandler);

    router.define(RouteConstants.ROUTE_LISTA_VET_ADM,
        handler: listaVetAdmHandler);
  }
}
