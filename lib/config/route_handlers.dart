import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_finey/screens/agenda_screen.dart';
import 'package:flutter_finey/screens/cadastro_pet_screen.dart';
import 'package:flutter_finey/screens/chat_users_screen.dart';
import 'package:flutter_finey/screens/compartilhar_screen.dart';
import 'package:flutter_finey/screens/consulta_screen.dart';
import 'package:flutter_finey/screens/exame_screen.dart';
import 'package:flutter_finey/screens/home_admin_screen/vet_admin_screen.dart';
import 'package:flutter_finey/screens/home_pet_widgets/home_adm_perfil.dart';
import 'package:flutter_finey/screens/home_screen_pet.dart';
import 'package:flutter_finey/screens/localizacao_screen.dart';
import 'package:flutter_finey/screens/pagamento_screen.dart';
import 'package:flutter_finey/screens/planos_screen.dart';
import 'package:flutter_finey/screens/qr_code_screen.dart';
import 'package:flutter_finey/screens/timeline_screen.dart';
import 'package:flutter_finey/screens/tutorial_screen.dart';
import 'package:flutter_finey/screens/vacina_screen.dart';
import '../screens/home_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/recuperar_senha_screen.dart';
import '../screens/login_screen.dart';
import '../screens/profile_guest_screen.dart';
import '../screens/profile_more_screen.dart';
import '../screens/report_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/walk_through_screen.dart';
import '../screens/premium_account_screen.dart';
import '../screens/verify_code_screen.dart';

/// Handler redirect to Home screen
var homeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new HomeScreen();
});

/// Handler redirect to Sign up screen
var signUpHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new SignupScreen();
});

/// Handler redirect to Verify code screen
var verifyCodeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new VerifyCodeScreen();
});


var loginHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new LoginScreen();
});

var forgotPasswordHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new ForgotPasswordScreen();
});

var profileGuestHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new ProfileGuestScreen();
});


var profileMoreHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new ProfileMoreScreen();
});


var reportHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new ReportScreen();
});

var splashHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new SplashScreen();
});


var walkThroughHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new WalkThroughScreen();
});


var premiumAccountHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new PremiumAccountScreen();
});

var cadastroPetHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new CadastroPetScreen();
});

var localizacaoPetHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new LocalizacaoScreen();
});

var chatPetHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new ChatUsersScreen();
    });

var vacinaHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new VacinaScreen();
    });

var exameHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new ExameScreen();
    });

var consultaHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new ConsultaScreen();
    });

var qrCodeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new QrCodeScreen();
    });

var agendaHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new AgendaScreen();
    });

var planosHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new PlanosScreen();
    });

var pagamentoHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new PagamentoScreen();
    });

var timelineHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new TimelineScreen();
    });

var tutorialHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new TutorialScreen();
    });

var compartilharHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new CompartilharScreen();
    });

var homePetHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new HomePetScreen();
    });

var homeAdmHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new HomeAdmPerfil();
    });

var listaVetAdmHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new VeterinarioAdminScreen();
    });