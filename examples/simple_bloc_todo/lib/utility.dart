import 'package:flutter/material.dart';

Key keyGenerator(String id, {String prefix = '', String suffix = ''})
  => Key('${prefix}__GeneratedKey__${id}__$suffix');
