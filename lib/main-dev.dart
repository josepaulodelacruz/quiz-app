import 'package:flutter/material.dart';
import 'package:rte_app/flavor_config.dart';
import 'package:rte_app/main.dart';

void main () async {
  FlavorConfig(
    flavor: Flavor.test,
    values: FlavorValues(
      baseUrl: "",
    ),
  );
  setupApp();
}