<!DOCTYPE html>
<html>
<head>
    <title>Lista Simple</title>
</head>
<body>
    <form method="POST">
        <input type="text" name="item" placeholder="Nuevo producto" required>
        <button type="submit">Agregar</button>
    </form>

    <h3>Tu lista:</h3>
    <ul>
        <?php
        // Si el usuario envió algo, lo mostramos de inmediato
        if (isset($_POST['item'])) {
            $producto = htmlspecialchars($_POST['item']);
            echo "<li><strong>Recién añadido:</strong> $producto</li>";
        }
        ?>
        <li>Ejemplo: Pan</li>
        <li>Ejemplo: Huevos</li>
    </ul>
</body>
</html>