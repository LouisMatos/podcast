package com.luismatos.podcast_app

import com.ryanheise.audioservice.AudioServiceActivity

// AudioServiceActivity (em vez de FlutterActivity) é o que permite o
// player continuar tocando com a tela apagada e os controles aparecerem
// na notificação/lockscreen. Ver docs/ROADMAP.md, Fase 4.
class MainActivity : AudioServiceActivity()
