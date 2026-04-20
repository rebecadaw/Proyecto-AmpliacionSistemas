<?php
// Recogemos la lista anterior y el nuevo producto
$listaAnterior = $_POST['lista_acumulada'] ?? '';
$nuevoProducto = $_POST['producto'] ?? '';

// Si hay un producto nuevo, lo añadimos a la cadena
if ($nuevoProducto) {
    $listaAnterior .= htmlspecialchars($nuevoProducto) . "<br>";
}
?>

<!DOCTYPE html>
<html>
<head><title>Lista de la Compra</title></head>
<body>
    <h2>🛒 Mi Lista</h2>
    
    <form method="POST">
        <!-- Campo oculto que guarda los productos anteriores -->
        <input type="hidden" name="lista_acumulada" value="<?php echo $listaAnterior; ?>">
        
        <input type="text" name="producto" placeholder="Añadir algo..." autofocus>
        <button type="submit">Añadir</button>
    </form>

    <div>
        <p><?php echo $listaAnterior; ?></p>
    </div>

    <hr>
    <a href="lista.php">Borrar todo</a>
</body>
</html>
