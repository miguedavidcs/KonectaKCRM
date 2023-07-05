<%@page import="java.text.*"%>
<%@ page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .container-center {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .form-container {
            max-width: 400px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
    </style>
    <title>Formulario de Usuarios</title>
</head>
<body>
    <div class="container-center">
        <div class="form-container">
            <h1 class="text-center mb-4">Formulario de Solicitud</h1>
            <form action="">
                <div class="form-group">
                    <label for="id_empleado">Nombre empleado:</label>
                    <select class="form-control" id="id_empleado" name="id_empleado">
                        <option value="">Seleccionar empleado...</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="codigo">Código:</label>
                    <input type="text" class="form-control" id="codigo" name="codigo" placeholder="Ingrese el código de la solicitud">
                </div>
                <div class="form-group">
                    <label for="descripcion">Descripción:</label>
                    <input type="text" class="form-control" id="descripcion" name="descripcion" placeholder="Describa de qué trata">
                </div>
                <div class="form-group">
                    <label for="resumen">Resumen:</label>
                    <input type="text" class="form-control" id="resumen" name="resumen" placeholder="Por qué">
                </div>
                <button type="submit" name="guardar" class="btn btn-primary btn-block">Guardar</button>
            </form>
            <%-- Lógica para procesar los datos del formulario --%>
            <% 
                if (request.getParameter("guardar") != null) {
                    String id_empleado = request.getParameter("id_empleado");
                    String codigo = request.getParameter("codigo");
                    String descripcion = request.getParameter("descripcion");
                    String resumen = request.getParameter("resumen");

                    if (id_empleado != null && !id_empleado.isEmpty() && codigo != null && !codigo.isEmpty() && descripcion != null && !descripcion.isEmpty()) {
                        // Los parámetros no están vacíos, puedes continuar con el procesamiento
                        int empleadoId = Integer.parseInt(id_empleado);
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/kcrm?user=root&password=");

                            String query = "INSERT INTO solicitud (id_empleado, codigo, descripcion, resumen) VALUES (?, ?, ?, ?)";
                            PreparedStatement pstmt = con.prepareStatement(query);
                            pstmt.setInt(1, empleadoId);
                            pstmt.setString(2, codigo);
                            pstmt.setString(3, descripcion);
                            pstmt.setString(4, resumen);

                            int rowsAffected = pstmt.executeUpdate();

                            if (rowsAffected > 0) {
                                out.println("<div class=\"alert alert-success mt-3\">Registro guardado correctamente.</div>");
                            } else {
                                out.println("<div class=\"alert alert-danger mt-3\">Error al guardar el registro.</div>");
                            }

                            pstmt.close();
                            con.close();
                        } catch (ClassNotFoundException | SQLException e) {
                            e.printStackTrace();
                            out.println("<div class=\"alert alert-danger mt-3\">Error al guardar el registro.</div>");
                        }
                    } else {
                        out.println("<div class=\"alert alert-danger mt-3\">Todos los campos son obligatorios.</div>");
                    }
                }
            %>
        </div>
    </div>

    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        // Obtener el elemento del ComboBox
        var comboBox = document.getElementById("id_empleado");

        // Agregar un evento de clic al ComboBox
        comboBox.addEventListener("click", function() {
            // Realizar la solicitud Ajax para obtener los empleados
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    // Procesar la respuesta y actualizar las opciones del ComboBox
                    var response = JSON.parse(xhr.responseText);
                    if (response.success) {
                        var employees = response.data;
                        comboBox.innerHTML = ""; // Limpiar las opciones existentes

                        // Agregar las nuevas opciones al ComboBox
                        employees.forEach(function(employee) {
                            var option = document.createElement("option");
                            option.value = employee.id;
                            option.text = employee.nombre;
                            comboBox.appendChild(option);
                        });
                    }
                }
            };

            // Realizar la solicitud GET al servidor para obtener los empleados
            xhr.open("GET", "obtener_empleados.jsp", true);
            xhr.send();
        });
    </script>
</body>
</html>
