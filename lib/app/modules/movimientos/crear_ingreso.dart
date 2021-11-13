import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:speech_app/app/data/db/com_item_table.dart';
import 'package:speech_app/app/data/db/parametros_table.dart';
import 'package:speech_app/app/data/models/com_item.dart';
import 'package:speech_app/app/data/models/config_parametro.dart';
import 'package:speech_app/app/data/models/movimientos_detalle.dart';
import 'package:speech_app/app/routes/app_routes.dart';
import 'package:speech_app/app/utils/color_app.dart';
import 'package:speech_app/app/utils/constant.dart';
import 'package:speech_app/app/utils/dialogs.dart';
import 'package:speech_app/app/utils/responsive.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'movimientos_controller.dart';

class CrearIngreso extends StatefulWidget {
  @override
  _CrearIngresoState createState() => _CrearIngresoState();
}

class _CrearIngresoState extends State<CrearIngreso> {
  String tipo = Get.parameters['tipo'];

  final _formKey = GlobalKey<FormState>();
  ParametrosTable dbParametros = ParametrosTable();
  ComItemTable dbComItems = ComItemTable();

  TextEditingController OCodigo = TextEditingController();
  TextEditingController OCantidad = TextEditingController();
  TextEditingController OGuia = TextEditingController();
  TextEditingController OTexto = TextEditingController();

  TextEditingController OCarga = TextEditingController();
  TextEditingController OBodega = TextEditingController();
  TextEditingController OLote = TextEditingController();
  SpeechToText _speechToText = SpeechToText();

  List<config_parametro> carga = [];
  List<config_parametro> bodega = [];
  List<com_item> items = [];

  bool _speechEnabled = false;

  @override
  void initState() {
    _initSpeech();
    loaderParametros();
    super.initState();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  Future<void> _start() async {
    await _speechToText.listen(onResult: _onSpeechResult);
  }

  Future<void> _stop() async {
    await _speechToText.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    String _lastWords = result.recognizedWords;
    _lastWords = _lastWords.toLowerCase();
    String split = _lastWords.split(' ')[1];
    if (_lastWords.contains("código")) {
      var itemOption =
          items.where((x) => x.codigo.toLowerCase() == split).toList();
      if (itemOption.isNotEmpty) {
        OCodigo.text = itemOption.first.codigo + "|" + itemOption.first.nombre;
      } else {
        OCodigo.text = "No dispoible";
      }
    }

    if (_lastWords.contains("guía")) {
      OGuia.text = split;
    }
    if (_lastWords.contains("cantidad")) {
      OCantidad.text = split;
    }
    if (_lastWords.contains("lote")) {
      OLote.text = split;
    }
    if (_lastWords.contains("carga")) {
      var cargaOption =
          carga.where((x) => x.valor.toLowerCase() == split).toList();
      if (cargaOption.isNotEmpty) {
        OCarga.text = cargaOption.first.valor;
      } else {
        OCarga.text = "No dispoible";
      }
    }

    if (_lastWords.contains("bodega")) {
      var cargaOption =
          bodega.where((x) => x.valor.toLowerCase() == split).toList();
      if (cargaOption.isNotEmpty) {
        OBodega.text = cargaOption.first.valor;
      } else {
        OBodega.text = "No dispoible";
      }
    }

    setState(() {
      OTexto.text = _lastWords;
    });
  }

  Future<void> loaderParametros() async {
    await dbParametros.getAll().then((x) {
      carga = x.where((x) => x.tipo == "recipiente-tipo").toList();
      bodega = x.where((x) => x.tipo == "tipo-bodega").toList();
    });

    await dbComItems.getAll().then((x) {
      items = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);

    return GetBuilder<MovimientosController>(
      id: "movimientos_page",
      builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(tipo),
            backgroundColor: ColorApp.Second,
            elevation: 0.0,
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () async {
                    await Get.toNamed(AppRoutes.SERVER);
                  },
                  icon: Icon(
                    Icons.computer,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Servidor',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: OGuia,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Dato obligatorio';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            decoration: textInputDecoration.copyWith(
                                icon: const Icon(Icons.email),
                                labelText: 'Guia :'),
                          ),
                          TextFormField(
                            controller: OCodigo,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Dato obligatorio';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            decoration: textInputDecoration.copyWith(
                                icon: const Icon(Icons.email),
                                labelText: 'Codigo :'),
                          ),
                          SizedBox(height: responsive.hp(3)),
                          TextFormField(
                            controller: OCantidad,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Dato obligatorio';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: textInputDecoration.copyWith(
                                icon: const Icon(Icons.email),
                                labelText: 'Cantidad :'),
                          ),
                          SizedBox(height: responsive.hp(3)),
                          TextFormField(
                            controller: OLote,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Dato obligatorio';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            decoration: textInputDecoration.copyWith(
                                icon: const Icon(Icons.receipt),
                                labelText: 'Lote :'),
                          ),
                          TextFormField(
                            controller: OCarga,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Dato obligatorio';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            decoration: textInputDecoration.copyWith(
                                icon: const Icon(Icons.receipt),
                                labelText: 'Carga :'),
                          ),
                          TextFormField(
                            controller: OBodega,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Dato obligatorio';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            decoration: textInputDecoration.copyWith(
                                icon: const Icon(Icons.home),
                                labelText: 'Bodega :'),
                          ),
                          SizedBox(height: responsive.hp(3)),
                          Text(OTexto.text),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FloatingActionButton(
                                child: Icon(Icons.check_circle_outline),
                                mini: true,
                                backgroundColor: Colors.green,
                                onPressed: () => _submit(_),
                              ),
                              FloatingActionButton(
                                child: Icon(Icons.mic),
                                mini: true,
                                backgroundColor: Colors.orange,
                                onPressed: _speechToText.isNotListening
                                    ? () => _start()
                                    : null,
                              ),
                              FloatingActionButton(
                                  child: Icon(Icons.sync),
                                  mini: true,
                                  backgroundColor: Colors.lightBlue,
                                  onPressed: () {
                                    sincronizarDatos(_);
                                  }),
                              FloatingActionButton(
                                  child: Icon(Icons.add),
                                  mini: true,
                                  backgroundColor: Colors.amber,
                                  onPressed: () {
                                    generarNuevo(_);
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                    color: ColorApp.Second,
                    alignment: Alignment.center,
                    child: Text("Detalles de items",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: responsive.ip(4),
                            fontWeight: FontWeight.w300)),
                  ),
                  Container(
                      height: size.height - 100,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (c, i) {
                            final movimientos_detalles item = _.data[i];

                            String enviadot =
                                (item.enviado == 1) ? "Enviado" : "Sin enviar";
                            return Slidable(
                                key: ValueKey(i),
                                actionPane: SlidableDrawerActionPane(),
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    color: ColorApp.Second,
                                    icon: Icons.close,
                                    closeOnTap: true,
                                    onTap: () {
                                      _.cancelarItem(i);
                                    },
                                  )
                                ],
                                dismissal: SlidableDismissal(
                                    child: SlidableDrawerDismissal()),
                                child: ListTile(
                                  title: new Text("Item: " +
                                      item.codigo +
                                      "|" +
                                      item.producto +
                                      " Guia: " +
                                      item.guia),
                                  subtitle: new Text("Cantidad: " +
                                      item.cantidad.toString() +
                                      " Lote: " +
                                      item.lote +
                                      " Empaque: " +
                                      item.carga +
                                      " Bodega: " +
                                      item.bodega +
                                      " Estado: " +
                                      enviadot),
                                ));
                          },
                          itemCount: _.data.length)),
                ],
              ),
            ),
          )),
    );
  }

  Future<void> _submit(MovimientosController _) async {
    if (_formKey.currentState.validate()) {
      var model = movimientos_detalles();
      model.id = 0;
      model.cantidad = double.parse(OCantidad.text);
      model.guia = OGuia.text;
      if (!OCodigo.text.isEmpty) {
        model.codigo = OCodigo.text.split('|')[0];
        model.producto = OCodigo.text.split('|')[1];
      }

      model.lote = OLote.text;
      model.carga_id = 0;
      model.bodega_id = 0;
      model.enviado = 0;
      model.tipo = tipo;
      model.entrada_id = 0;

      var parametros = await dbParametros.getAll();
      if (parametros.isNotEmpty) {
        var Ocarga = parametros
            .where((element) => element.valor == OCarga.text)
            .toList();

        if (Ocarga.isNotEmpty) {
          model.carga_id = Ocarga.first.idservices;
          model.carga = Ocarga.first.valor;
        }
        var Obodega = parametros
            .where((element) => element.valor == OBodega.text)
            .toList();
        if (Obodega.isNotEmpty) {
          model.bodega_id = Obodega.first.idservices;
          model.bodega = Obodega.first.valor;
        }
      }

      await _.onSubmit(model).whenComplete(() {
        _.cargarDetalle(tipo);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Guardado')),
        );
      });
    }
  }

  Future<void> sincronizarDatos(MovimientosController _) async {
    ProgressDialog.show(context, "Enviando Datos");
    _.sincronizar(tipo).whenComplete(() {
      _
          .cargarDetalle(tipo)
          .whenComplete(() => ProgressDialog.dissmiss(context));
    }).whenComplete(() => ProgressDialog.dissmiss(context));
  }

  Future<void> generarNuevo(MovimientosController _) async {
    Get.dialog(AlertDialog(
      title: Text('Advertencia'),
      content: Text("Esta seguro de crear un nuevo registro"),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              _.CrearNuevo(tipo).then((value) {
                _.cargarDetalle(tipo).then((value) => Get.back());
              });
            },
            child: Text("Si")),
        FlatButton(
            onPressed: () {
              Get.back();
            },
            child: Text("No"))
      ],
    ));
  }
}
