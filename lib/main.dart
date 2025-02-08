import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cafe_app.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://rrjzlxmsasoblyirdner.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJyanpseG1zYXNvYmx5aXJkbmVyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjI4NjAwMzIsImV4cCI6MjAzODQzNjAzMn0.pxI68RjlxtpEDzpU_vLQs9JM8W1LxR1K7A3fw3nLeEY',
  );
  await Hive.initFlutter();
  runApp(const CafeApp());
}
