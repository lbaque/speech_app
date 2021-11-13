import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:speech_app/app/data/db/parametros_table.dart';
import 'package:speech_app/app/data/db/saldos_table.dart';
import 'package:speech_app/app/data/models/movimientos_detalle.dart';
import 'package:speech_app/app/data/models/saldos.dart';
import 'package:speech_app/app/routes/app_routes.dart';
import 'package:speech_app/app/utils/color_app.dart';
import 'package:speech_app/app/utils/constant.dart';
import 'package:speech_app/app/utils/dialogs.dart';
import 'package:speech_app/app/utils/responsive.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'movimientos_controller.dart';

class CrearEgreso extends StatefulWidget {
  @override
  _CrearEgresoState createState() => _CrearEgresoState();
}

class _CrearEgresoState extends State<CrearEgreso> {
  String tipo = Get.parameters['tipo'];

  final _formKey = GlobalKey<FormState>();
  ParametrosTable dbParametros = ParametrosTable();
  SaldosTable dbSaldos = SaldosTable();

  TextEditingController OCodigo = TextEditingController();
  TextEditingController OCantidad = TextEditingController();
  TextEditingController OGuia = TextEditingController();
  TextEditingController OTexto = TextEditingController();

  TextEditingController OCarga = TextEditingController();
  TextEditingController OBodega = TextEditingController();
  TextEditingController OLote = TextEditingController();
  SpeechToText _speechToText = SpeechToText();

  List<saldos> entrada = [];
  List<DropdownMenuItem> dropdowEntrada = [];
  int valuex;
  double disponible = 0;
  bool _speechEnabled = false;

  @override
  void initState() {
    _initSpeech();
    loaderParametros();
    super.initState();
  }

  Future<void> loaderParametros() async {
    await dbSaldos.getAll().then((x) {
      entrada = x;
    });
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
      dropdowEntrada = [];
      var entradaOption =
          entrada.where((x) => x.codigo.toLowerCase() == split).toList();
      if (entradaOption.isNotEmpty) {
        List<DropdownMenuItem> lista = [];

        entradaOption.forEach((element) {
          lista.add(DropdownMenuItem(
              value: element.entrada_id,
              child: Text(
                  "Doc: " +
                      element.guia +
                      "|" +
                      element.producto +
                      "|Disponible : " +
                      element.cantidad.toString() +
                      "|" +
                      element.carga,
                  style: TextStyle(fontSize: 10))));
        });

        var obj = entrada
            .where((element) =>
                element.entrada_id == entradaOption.first.entrada_id)
            .toList();

        setState(() {
          dropdowEntrada = lista;
          valuex = entradaOption.first.entrada_id;
          disponible = (obj.isNotEmpty) ? obj.first.cantidad : 0;
          OCantidad.text = "";
        });

        OCarga.text = entradaOption.first.carga;
        OBodega.text = entradaOption.first.bodega;
        OCodigo.text = split + "|" + entradaOption.first.producto;
      } else {
        OCodigo.text = "";
      }
    }

    if (_lastWords.contains("guía")) {
      OGuia.text = split;
    }
    if (_lastWords.contains("cantidad")) {
      OCantidad.text = split;
    }

    setState(() {
      OTexto.text = _lastWords;
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
                          DropdownButtonFormField(
                              menuMaxHeight: size.height,
                              validator: (value) {
                                if (value == null) {
                                  return 'Dato obligatorio';
                                }

                                return null;
                              },
                              hint: Text("Entrada"),
                              decoration: InputDecoration(
                                  icon: const Icon(Icons.timer)),
                              onChanged: (x) {
                                var obj = entrada
                                    .where((element) => element.entrada_id == x)
                                    .toList();

                                setState(() {
                                  disponible =
                                      (obj.isNotEmpty) ? obj.first.cantidad : 0;
                                  valuex = x;
                                });
                              },
                              value: valuex,
                              items: (dropdowEntrada.toList().length > 0)
                                  ? dropdowEntrada.toList()
                                  : []),
                          SizedBox(height: responsive.hp(3)),
                          TextFormField(
                            controller: OCantidad,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Dato obligatorio';
                              }
                              if (value == 0) {
                                return 'Debe ser mayor a 0';
                              }
                              if (double.parse(value) > disponible) {
                                return 'Stock insuficiente';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: textInputDecoration.copyWith(
                                icon: const Icon(Icons.email),
                                labelText: 'Cantidad :'),
                          ),
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
                                    sincronizarDatos(_).whenComplete(() {
                                      _.cargarSaldo().whenComplete(
                                          () => loaderParametros());
                                    });
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

      model.entrada_id = valuex;
      model.lote = OLote.text;
      model.carga_id = 0;
      model.bodega_id = 0;
      model.enviado = 0;
      model.tipo = tipo;

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
    await _.sincronizar(tipo).whenComplete(() => _.cargarDetalle(tipo));
    ProgressDialog.dissmiss(context);
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
