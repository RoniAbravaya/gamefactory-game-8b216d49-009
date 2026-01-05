import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../services/analytics_service.dart';
import '../config/levels.dart';

/// Main game class for test6-platformer-09
/// 
/// Manages game state, level progression, and core gameplay loop.
class test6-platformer-09Game extends FlameGame 
    with HasCollisionDetection, TapDetector {
  
  // Services (injected from Flutter)
  late AnalyticsService analyticsService;
  
  // Game state
  GameState state = GameState.menu;
  int currentLevel = 1;
  int score = 0;
  int lives = 3;
  
  // Level configuration
  LevelConfig? levelConfig;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add camera
    camera.viewfinder.visibleGameSize = Vector2(400, 800);
    
    // Load initial level
    await loadLevel(currentLevel);
  }
  
  Future<void> loadLevel(int level) async {
    // Clear existing components
    removeAll(children.whereType<Component>());
    
    // Get level config
    levelConfig = LevelConfigs.getLevel(level);
    
    // Log analytics
    analyticsService.logLevelStart(level);
    
    // Update state
    state = GameState.playing;
    score = 0;
    
    // TODO: Add level-specific components
  }
  
  @override
  void onTapDown(TapDownInfo info) {
    if (state != GameState.playing) return;
    
    // Handle tap input
    final position = info.eventPosition.widget;
    // TODO: Implement tap handling based on mechanics
  }
  
  void onLevelComplete() {
    state = GameState.levelComplete;
    analyticsService.logLevelComplete(currentLevel, score);
    overlays.add('LevelCompleteOverlay');
  }
  
  void onGameOver() {
    state = GameState.gameOver;
    analyticsService.logLevelFail(currentLevel, score);
    overlays.add('GameOverOverlay');
  }
  
  void nextLevel() {
    currentLevel++;
    loadLevel(currentLevel);
  }
  
  void restartLevel() {
    loadLevel(currentLevel);
  }
}

enum GameState {
  menu,
  playing,
  paused,
  levelComplete,
  gameOver,
}
