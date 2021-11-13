import 'dart:ffi';

class movimientos_detalles {
  int id;
  String guia;
  String codigo;
  double cantidad;
  String lote;
  int carga_id;
  int bodega_id;
  int enviado;
  String carga;
  String bodega;
  String producto;
  String tipo;
  int entrada_id;

  movimientos_detalles(
      {this.id,
      this.guia,
      this.codigo,
      this.cantidad,
      this.lote,
      this.carga_id,
      this.bodega_id,
      this.enviado,
      this.bodega,
      this.carga,
      this.producto,
      this.tipo,
      this.entrada_id});

  factory movimientos_detalles.fromMap(Map<String, dynamic> json) {
    return movimientos_detalles(
      id: json["id"],
      guia: json["guia"],
      codigo: json["codigo"],
      cantidad: json["cantidad"],
      lote: json["lote"],
      carga_id: json["carga_id"],
      bodega_id: json["bodega_id"],
      enviado: json["enviado"],
      bodega: json["bodega"],
      carga: json["carga"],
      producto: json["producto"],
      tipo: json["tipo"],
      entrada_id: json["entrada_id"],
    );
  }

  Map<String, dynamic> toMap() => {
        'guia': guia,
        'codigo': codigo,
        'cantidad': cantidad,
        'lote': lote,
        'carga_id': carga_id,
        'bodega_id': bodega_id,
        'enviado': enviado,
        'bodega': bodega,
        'carga': carga,
        'producto': producto,
        'tipo': tipo,
        'entrada_id': entrada_id,
      };
}
