import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:speech_app/app/routes/app_routes.dart';
import 'package:speech_app/app/utils/constant.dart';
import 'package:speech_app/app/utils/responsive.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: gradientEndColor,
            body: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1F8909),
                          const Color(0xFFF1D768)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 1.0])),
                child: SafeArea(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 18.0,
                                  ),
                                  Text(
                                    'Menú Principal',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 30,
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.w900,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Row(children: [
                                SizedBox(width: 18.0),
                                Text(
                                  'Seleccione su módulo',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w900,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ]),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.toNamed(AppRoutes.MCINGRESO,
                                                parameters: {
                                                  'tipo': 'Ingresos'
                                                });
                                          },
                                          child: Container(
                                            height: 180,
                                            width: size.width,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/principal_ingreso.png"),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            margin: const EdgeInsets.only(
                                                left: 20, top: 30, bottom: 15),
                                          ),
                                        ),
                                        Container(
                                            // color: Colors.red,
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            margin:
                                                const EdgeInsets.only(left: 24),
                                            child: const Text(
                                                "Ingreso de Producto",
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xffffffff),
                                                )))
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.toNamed(AppRoutes.MCEGRESO,
                                                parameters: {
                                                  'tipo': 'Egresos'
                                                });
                                          },
                                          child: Container(
                                            height: 180,
                                            width: size.width,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/principal_egreso.png"),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            margin: const EdgeInsets.only(
                                                right: 10, top: 30, bottom: 15),
                                          ),
                                        ),
                                        Container(
                                            // color: Colors.red,
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(
                                                right: 18, left: 4),
                                            child: const Text(
                                                "Egreso de Producto ",
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xffffffff),
                                                )))
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.toNamed(AppRoutes.SERVER);
                                          },
                                          child: Container(
                                            height: 180,
                                            width: size.width,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/config.png"),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            margin: const EdgeInsets.only(
                                                right: 10, top: 30, bottom: 15),
                                          ),
                                        ),
                                        Container(
                                            // color: Colors.red,
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(
                                                right: 18, left: 4),
                                            child: const Text("Configuración",
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xffffffff),
                                                )))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ]),
                ))));
  }
}
