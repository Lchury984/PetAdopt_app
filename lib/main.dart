import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:petadopt_prueba2_app/core/constants/app_constants.dart';
import 'package:petadopt_prueba2_app/core/constants/app_routes.dart';
import 'package:petadopt_prueba2_app/core/theme/app_theme.dart';
import 'package:petadopt_prueba2_app/injection_container.dart' as di;
import 'package:petadopt_prueba2_app/injection_container.dart';
import 'package:petadopt_prueba2_app/features/chat/presentation/pages/chat_page.dart';

// Auth
import 'package:petadopt_prueba2_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:petadopt_prueba2_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:petadopt_prueba2_app/features/auth/presentation/pages/login_page.dart';
import 'package:petadopt_prueba2_app/features/auth/presentation/pages/select_role_page.dart';
import 'package:petadopt_prueba2_app/features/auth/presentation/pages/register_page.dart';

// Pets
import 'package:petadopt_prueba2_app/features/pets/presentation/pages/pet_detail_page.dart';
import 'package:petadopt_prueba2_app/features/pets/presentation/pages/pet_form_page.dart';
import 'package:petadopt_prueba2_app/features/pets/presentation/pages/adopter_home_page.dart';
import 'package:petadopt_prueba2_app/features/pets/presentation/pages/shelter_home_page.dart';
import 'package:petadopt_prueba2_app/features/pets/domain/entities/pet_entity.dart';

// Adoption
import 'package:petadopt_prueba2_app/features/adoption/presentation/pages/adopter_requests_page.dart';
import 'package:petadopt_prueba2_app/features/adoption/presentation/pages/shelter_requests_page.dart';

// Chat AI
import 'package:petadopt_prueba2_app/features/chat_ai/presentation/pages/chat_ai_page.dart';

// Map
import 'package:petadopt_prueba2_app/features/map/presentation/pages/map_page.dart';

// Cubits for other modules
import 'package:petadopt_prueba2_app/features/pets/presentation/cubit/pets_cubit.dart';
import 'package:petadopt_prueba2_app/features/adoption/presentation/cubit/adoption_cubit.dart';
import 'package:petadopt_prueba2_app/features/chat_ai/presentation/cubit/chat_ai_cubit.dart';
import 'package:petadopt_prueba2_app/features/map/presentation/cubit/map_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables del .env
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseKey,
  );

  await di.initDependencies();

  runApp(const PetAdoptApp());
}

class PetAdoptApp extends StatelessWidget {
  const PetAdoptApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Envolver con ProviderScope para Riverpod
    return ProviderScope(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<AuthCubit>()..checkAuthentication()),
          BlocProvider(create: (_) => sl<PetsCubit>()),
          BlocProvider(create: (_) => sl<AdoptionCubit>()),
          BlocProvider(create: (_) => sl<ChatAiCubit>()),
          BlocProvider(create: (_) => sl<MapCubit>()),
        ],
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            // Determinar tema según el rol del usuario
            ThemeData theme = AppTheme.lightTheme;
            if (authState is AuthAuthenticated) {
              theme = authState.role == 'shelter'
                  ? AppTheme.shelterTheme
                  : AppTheme.adopterTheme;
            }

            return MaterialApp(
              title: 'PetAdopt',
              debugShowCheckedModeBanner: false,
              theme: theme,
              onGenerateRoute: _onGenerateRoute,
              initialRoute: AppRoutes.splash,
            );
          },
        ),
      ),
    );
  }
}

Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.splash:
      return MaterialPageRoute(builder: (_) => const SplashPage());
    case AppRoutes.login:
      return MaterialPageRoute(builder: (_) => const LoginPage());
    case AppRoutes.selectRole:
      return MaterialPageRoute(builder: (_) => const SelectRolePage());
    case AppRoutes.register:
      final role = settings.arguments as String? ?? 'adopter';
      return MaterialPageRoute(builder: (_) => RegisterPage(role: role));
    case AppRoutes.adopterHome:
      final adopterId = settings.arguments as String? ?? '';
      return MaterialPageRoute(
        builder: (_) => AdopterHomePage(adopterId: adopterId),
      );
    case AppRoutes.petDetail:
      final pet = settings.arguments as PetEntity;
      return MaterialPageRoute(builder: (_) => PetDetailPage(pet: pet));
    case AppRoutes.managePets:
    case AppRoutes.shelterHome:
      final shelterId = settings.arguments as String? ?? '';
      return MaterialPageRoute(
        builder: (_) => ShelterHomePage(shelterId: shelterId),
      );
    case AppRoutes.addPet:
      final shelterId = settings.arguments as String? ?? '';
      return MaterialPageRoute(
        builder: (_) => PetFormPage(
          mode: PetFormMode.create,
          shelterId: shelterId,
        ),
      );
    case AppRoutes.editPet:
      final args = settings.arguments as Map<String, dynamic>?;
      final shelterId = args?['shelterId'] as String? ?? '';
      final pet = args?['pet'] as PetEntity?;
      return MaterialPageRoute(
        builder: (_) => PetFormPage(
          mode: PetFormMode.edit,
          shelterId: shelterId,
          pet: pet,
        ),
      );
    case AppRoutes.adoptionRequests:
      final adopterId = settings.arguments as String? ?? '';
      return MaterialPageRoute(
        builder: (_) => AdopterRequestsPage(adopterId: adopterId),
      );
    case AppRoutes.shelterRequests:
      final shelterId = settings.arguments as String? ?? '';
      return MaterialPageRoute(
        builder: (_) => ShelterRequestsPage(shelterId: shelterId),
      );
    case AppRoutes.chatAi:
      return MaterialPageRoute(builder: (_) => const ChatAiPage());
    case 'chat':
      return MaterialPageRoute(builder: (_) => const ChatPage());
    case AppRoutes.map:
      return MaterialPageRoute(builder: (_) => const MapPage());
    default:
      return MaterialPageRoute(builder: (_) => const SplashPage());
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            if (state.role == AppConstants.roleShelter) {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.shelterHome,
                arguments: state.userId,
              );
            } else {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.adopterHome,
                arguments: state.userId,
              );
            }
          } else if (state is AuthUnauthenticated || state is AuthLoggedOut) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.login);
          }
        },
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando...'),
              ],
            ),
          );
        },
      ),
    );
  }
}
