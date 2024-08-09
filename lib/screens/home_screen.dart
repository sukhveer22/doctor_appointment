import 'package:doctor_appointment/controllers/sign_controller.dart';
import 'package:doctor_appointment/models/user_model.dart';
import 'package:doctor_appointment/screens/login_screen.dart';
import 'package:doctor_appointment/util/app_color.dart';
import 'package:doctor_appointment/util/custom_text_field.dart';
import 'package:doctor_appointment/util/doctor_util.dart';
import 'package:doctor_appointment/util/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Doctor {
  final String imagePath;
  final String title;
  final String description;
  final double rating;

  Doctor({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.rating,
  });
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();
  List<Doctor> doctors = [
    Doctor(
      imagePath: Assets.doctor1,
      title: 'Dr. John Doe',
      description:
          'Dr. John Doe is a renowned cardiologist with over 15 years of experience. He specializes in heart disease prevention and treatment. He is known for his compassionate care and innovative approaches to cardiology.',
      rating: 4.5,
    ),
    Doctor(
      imagePath: Assets.doctor1,
      title: 'Dr. Jane Smith',
      description:
          'Dr. Jane Smith is an experienced endocrinologist specializing in thyroid disorders and diabetes management. She is highly regarded for her patient-centered approach and expertise in hormone-related conditions.',
      rating: 4.7,
    ),
    Doctor(
      imagePath: Assets.doctor1,
      title: 'Dr. Emily Johnson',
      description:
          'Dr. Emily Johnson is a skilled neurologist with a focus on neurological disorders and stroke rehabilitation. Her extensive research and personalized treatment plans have earned her a top rating among her peers.',
      rating: 4.8,
    ),
    Doctor(
      imagePath: Assets.doctor1,
      title: 'Dr. Michael Brown',
      description:
          'Dr. Michael Brown is a prominent orthopedic surgeon specializing in joint replacement and sports injuries. He is well-known for his advanced surgical techniques and commitment to patient recovery.',
      rating: 4.6,
    ),
    Doctor(
      imagePath: Assets.doctor1,
      title: 'Dr. Sarah Davis',
      description:
          'Dr. Sarah Davis is a highly respected family medicine doctor with a focus on preventive care and chronic disease management. Her holistic approach and dedication to patient well-being are widely appreciated.',
      rating: 4.9,
    ),
    Doctor(
      imagePath: Assets.doctor2,
      title: 'Dr. David Wilson',
      description:
          'Dr. David Wilson is a leading pulmonologist with expertise in respiratory diseases and sleep disorders. He is known for his thorough diagnostic skills and innovative treatments in pulmonary medicine.',
      rating: 4.4,
    ),
    Doctor(
      imagePath: Assets.doctor2,
      title: 'Dr. Jessica Martinez',
      description:
          'Dr. Jessica Martinez is a distinguished dermatologist specializing in skin cancer and cosmetic dermatology. Her expertise and patient-focused care have earned her high praise in the field of dermatology.',
      rating: 4.7,
    ),
    Doctor(
      imagePath: Assets.doctor2,
      title: 'Dr. Robert Anderson',
      description:
          'Dr. Robert Anderson is a skilled gastroenterologist with a focus on digestive disorders and liver diseases. His advanced diagnostic techniques and personalized treatment plans are well-regarded in his field.',
      rating: 4.6,
    ),
    Doctor(
      imagePath: Assets.doctor2,
      title: 'Dr. Laura Thomas',
      description:
          'Dr. Laura Thomas is an expert rheumatologist specializing in autoimmune diseases and arthritis management. Her compassionate care and cutting-edge treatments make her a top choice for her patients.',
      rating: 4.5,
    ),
    Doctor(
      imagePath: Assets.doctor2,
      title: 'Dr. William Jackson',
      description:
          'Dr. William Jackson is a prominent urologist with expertise in urinary tract disorders and prostate health. His advanced surgical techniques and dedication to patient care are highly praised.',
      rating: 4.8,
    ),
  ];
  SignUpController signUpController = Get.put(SignUpController());
  UserModel userModel = UserModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) async {
      userModel = await signUpController.getUserFromPreferences()??UserModel();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(userModel.email.toString());
    return Scaffold(
      drawerScrimColor: Colors.white,
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 280.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(18.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(builder: (context) {
                        return GestureDetector(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: const Icon(
                            CupertinoIcons.decrease_indent,
                            color: Colors.white,
                          ),
                        );
                      }),
                      const Icon(
                        CupertinoIcons.person_alt,
                        color: Colors.white,
                      )
                    ],
                  ),
                  SizedBox(height: 20.h),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "Let's find",
                    style: TextStyle(
                      fontSize: 35.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "your top doctor!",
                    style: TextStyle(
                      fontSize: 35.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: CustomTextField(
                      prefixIcon: const Icon(CupertinoIcons.search),
                      controller: controller,
                      hintText: "Search health issue...",
                    ),
                  ),
                ],
              ).paddingAll(15),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Text(
                  "Categories",
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomRowContent(
                  imagePaths: [
                    Assets.con3.toString(),
                    Assets.con1.toString(),
                    Assets.con2.toString(),
                    Assets.con4.toString(),
                  ],
                  texts: const [
                    "All",
                    "Cardiology",
                    "Medicine",
                    "General",
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ).paddingSymmetric(
              horizontal: 20,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return CustomCard(doctor: doctors[index])
                    .paddingSymmetric(horizontal: 10);
              },
              childCount: doctors.length,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: FutureBuilder<User?>(
                future: _getCurrentUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching user'));
                  } else if (snapshot.hasData && snapshot.data != null) {
                    User user = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: user.photoURL != null
                              ? NetworkImage(user.photoURL!)
                              : null,
                          radius: 30.0,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user.displayName ?? 'No Name',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.email ?? 'No Email',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: Text('No user logged in'));
                  }
                },
              ),
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAll(LoginScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<User?> _getCurrentUser() async {
  return FirebaseAuth.instance.currentUser;
}
