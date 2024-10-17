import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:evry_app/product/extensions/context_extension.dart';
import '../../../../product/constants/colors.dart';
import '../../../views/login/giris_ekrani_view.dart';
import '../../../views/onboard/downScreen/home/google_maps_screen.dart';
import '../otp/otp_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key, this.initialPhone});
  final String? initialPhone;

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool _obscureText = true;

  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  Color borderColor = AppColors.greyColor;
  late String phone;
  String _selectedCountryCode = '+1'; // Varsayılan ülke kodu

  bool isLogin = false;
  @override
  void initState() {
    super.initState();
    phone = widget.initialPhone ?? '';
  }

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.08)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: context.dynamicHeight(0.1)),
                const Flexible(
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/arac.png"),
                    maxRadius: 50,
                  ),
                ),
                SizedBox(height: context.dynamicHeight(0.05)),
                Flexible(
                  child: Text(
                    "Lütfen Bilgilerinizi Giriniz",
                    style: ContextExtension(context).theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          fontSize: 20,
                        ),
                  ),
                ),
                SizedBox(height: context.dynamicHeight(0.02)),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Adınız Soyadınız",
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: context.dynamicWidth(0.05),
                      vertical: context.dynamicHeight(0.025),
                    ),
                  ),
                ),
                SizedBox(height: context.dynamicHeight(0.02)),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "E-posta Adresiniz",
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: context.dynamicWidth(0.05),
                      vertical: context.dynamicHeight(0.025),
                    ),
                  ),
                ),
                SizedBox(height: context.dynamicHeight(0.02)),
                Row(
                  children: [
                    DropdownButton<String>(
                      value: _selectedCountryCode,
                      items: <String>['+1', '+90', '+44', '+49', '+33'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCountryCode = newValue!;
                        });
                      },
                    ),
                    SizedBox(width: context.dynamicWidth(0.02)),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                          labelText: "Telefon Numaranız",
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: context.dynamicWidth(0.05),
                            vertical: context.dynamicHeight(0.025),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.dynamicHeight(0.02)),
                TextField(
                  controller: passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: "Şifre Giriniz",
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: context.dynamicWidth(0.05),
                      vertical: context.dynamicHeight(0.025),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: context.dynamicHeight(0.02)),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                SizedBox(height: context.dynamicHeight(0.04)),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            String phoneNumber = '$_selectedCountryCode${phoneController.text.trim()}';

                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: phoneNumber,
                              verificationCompleted: (PhoneAuthCredential credential) async {
                                // Otomatik doğrulama ve giriş işlemi burada yapılır
                                await FirebaseAuth.instance.signInWithCredential(credential);
                                setState(() {
                                  isLoading = false;
                                });

                                // Telefon doğrulandıktan sonra kullanıcı verilerini kaydet
                                await saveUserData();
                              },
                              verificationFailed: (FirebaseAuthException error) {
                                setState(() {
                                  isLoading = false;
                                  errorMessage = error.message;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(error.message ?? "Bir hata oluştu")),
                                );
                              },
                              codeSent: (String verificationId, int? forceResendingToken) {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return OtpView(
                                    verificationId: verificationId,
                                    // Doğrulama tamamlandıktan sonra verileri kaydedin
                                    onVerificationCompleted: () async {
                                      await saveUserData();
                                    },
                                  );
                                }));
                              },
                              codeAutoRetrievalTimeout: (String verificationId) {
                                setState(() {
                                  isLoading = false;
                                });
                              },
                            );
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                              errorMessage = e.toString();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Telefon doğrulama başarısız: $e')),
                            );
                          }
                        },
                        child: Text("Gönder"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.greenColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: context.dynamicWidth(0.05),
                            vertical: context.dynamicHeight(0.025),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveUserData() async {
    String name = nameController.text;
    String email = emailController.text;
    String phoneNumber = phoneController.text;
    String password = passwordController.text; // Şifreyi sadece Firebase Auth ile kaydedin

    if (name.isNotEmpty && email.isNotEmpty && phoneNumber.isNotEmpty) {
      try {
        // Firebase Authentication ile kullanıcıyı oluşturun
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Kullanıcı kaydedildikten sonra Firestore'a veri ekleyin
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('users').doc(userCredential.user?.uid).set({
          'name': name,
          'email': email,
          'phone': phoneNumber,
        });

        // Başarılı bir şekilde kaydedildiğinde başka bir sayfaya geçiş veya bildirim gösterebilirsiniz
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const GoogleMapsScreen()),
        );
      } catch (e) {
        print('Kullanıcı kaydı hatası: $e');
        setState(() {
          errorMessage = 'Kullanıcı kaydı başarısız: ${e.toString()}';
        });
      }
    } else {
      setState(() {
        errorMessage = 'Lütfen tüm alanları doldurun.';
      });
    }
  }
}
