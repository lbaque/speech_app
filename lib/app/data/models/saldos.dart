import 'dart:ffi';

class saldos {
  int id;
  String codigo;
  double cantidad;
  String lote;
  int carga_id;
  int bodega_id;
  String carga;
  String bodega;
  String producto;
  int entrada_id;
  String guia;

  saldos(
      {this.id,
      this.codigo,
      this.cantidad,
      this.lote,
      this.carga_id,
      this.bodega_id,
      this.bodega,
      this.carga,
      this.producto,
      this.entrada_id,
      this.guia});

  factory saldos.fromMap(Map<String, dynamic> json) {
    return saldos(
      id: json["id"],
      codigo: json["codigo"],
      cantidad: json["cantidad"],
      lote: json["lote"],
      carga_id: json["carga_id"],
      bodega_id: json["bodega_id"],
      bodega: json["bodega"],
      carga: json["carga"],
      producto: json["producto"],
      entrada_id: json["entrada_id"],
      guia: json["guia"],
    );
  }

  Map<String, dynamic> toMap() => {
        'codigo': codigo,
        'cantidad': cantidad,
        'lote': lote,
        'carga_id': carga_id,
        'bodega_id': bodega_id,
        'bodega': bodega,
        'carga': carga,
        'producto': producto,
        'entrada_id': entrada_id,
        'guia': guia
      };
}
