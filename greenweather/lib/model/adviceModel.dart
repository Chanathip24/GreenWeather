import 'package:flutter/material.dart';

class Advicemodel {
    final String description;
    final String generalAdvice;
    final String sensitiveAdvice;
    final String outdoorAdvice;
    final String status;
    final Color color;

    Advicemodel({required this.description,required this.generalAdvice,required this.sensitiveAdvice,required this.outdoorAdvice,required this.status,required this.color});
    factory Advicemodel.fromJson(Map<String, dynamic> json) {
        return Advicemodel(
            description: json['description'] ?? "",
            generalAdvice: json['generalAdvice'] ?? "",
            sensitiveAdvice: json['sensitiveAdvice'] ?? "",
            outdoorAdvice: json['outdoorAdvice'] ?? "",
            status: json['status'] ?? "",
            color: json['color'] ?? Colors.white, // Default color if not provided
        );
    }

}