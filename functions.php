<?php
function lista_compra_estilos() {
    wp_enqueue_style('lista-compra-style', get_stylesheet_uri());
}
add_action('wp_enqueue_scripts', 'lista_compra_estilos');