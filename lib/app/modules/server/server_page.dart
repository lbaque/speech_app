import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_app/app/modules/server/server_controller.dart';
import 'package:speech_app/app/utils/color_app.dart';
import 'package:speech_app/app/utils/constant.dart';
import 'package:speech_app/app/utils/dialogs.dart';
import 'package:speech_app/app/utils/responsive.dart';

class ServerPage extends StatefulWidget {
  const ServerPage({Key key}) : super(key: key);

  @override
  State<ServerPage> createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
  @override
  Widget build(BuildContext context) {
    ServerController _server = ServerController();

    TextEditingController OUrl = TextEditingController();
    TextEditingController OIp = TextEditingController();
    TextEditingController OPort = TextEditingController();

    OUrl.text = _server.data.url;
    OIp.text = _server.data.ip;
    OPort.text = _server.data.port;

    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);

    return GetBuilder<ServerController>(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text('Servidor'),
          backgroundColor: ColorApp.Second,
          elevation: 0.0,
        ),
        body: Center(
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                    width: size.width,
                    height: size.height,
                    child: Stack(children: <Widget>[
                      SingleChildScrollView(
                          child: Container(
                              width: size.width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: responsive.ip(2)),
                              child: SafeArea(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        SizedBox(height: responsive.hp(4)),
                                        Text(
                                          "Bienvenido \n Registre los datos del servidor",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: responsive.ip(2),
                                              fontWeight: FontWeight.w300),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: 350,
                                            minWidth: 350,
                                          ),
                                          child: Form(
                                            child: Column(
                                              children: <Widget>[
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.text,
                                                  // controller: OUrl,
                                                  decoration: textInputDecoration
                                                      .copyWith(
                                                          icon: const Icon(
                                                              Icons.directions),
                                                          labelText: 'URL'),
                                                  validator: (val) {
                                                    return val == null
                                                        ? 'Dato obligatorio'
                                                        : null;
                                                  },
                                                  onChanged: (val) =>
                                                      _.onURLChanged(val),
                                                ),
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.text,
                                                  //controller: OIp,
                                                  decoration: textInputDecoration
                                                      .copyWith(
                                                          icon: const Icon(Icons
                                                              .contact_page),
                                                          labelText: 'IP'),
                                                  validator: (val) {
                                                    return val == null
                                                        ? 'Dato obligatorio'
                                                        : null;
                                                  },
                                                  onChanged: (val) =>
                                                      _.onIPChanged(val),
                                                ),
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  //controller: OPort,
                                                  decoration: textInputDecoration
                                                      .copyWith(
                                                          icon: const Icon(
                                                              Icons.portrait),
                                                          labelText: 'PORT'),
                                                  validator: (val) {
                                                    return val == null
                                                        ? 'Dato obligatorio'
                                                        : null;
                                                  },
                                                  onChanged: (val) =>
                                                      _.onPORTChanged(val),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: responsive.hp(4)),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: 350,
                                            minWidth: 350,
                                          ),
                                          child: CupertinoButton(
                                            padding: EdgeInsets.symmetric(
                                                vertical: responsive.ip(2)),
                                            color: ColorApp.Primary,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            onPressed: () => _.onCreate(),
                                            child: Text("Registrar",
                                                style: TextStyle(
                                                    color: ColorApp.lightText,
                                                    fontSize:
                                                        responsive.ip(2.5))),
                                          ),
                                        ),
                                        SizedBox(height: responsive.hp(4)),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: 350,
                                            minWidth: 350,
                                          ),
                                          child: CupertinoButton(
                                            padding: EdgeInsets.symmetric(
                                                vertical: responsive.ip(2)),
                                            color: ColorApp.Primary,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            onPressed: () => sincronizarDatos(_),
                                            child: Text("Sincronizar",
                                                style: TextStyle(
                                                    color: ColorApp.lightText,
                                                    fontSize:
                                                        responsive.ip(2.5))),
                                          ),
                                        ),
                                      ],
                                    )
                                  ]))))
                    ])))),
      ),
    );
  }

  Future <void> sincronizarDatos(ServerController _) async {

    ProgressDialog.show(context,"Sincronizando Parametros");
    await _.onSincronizar();
    ProgressDialog.dissmiss(context);
  }
}
