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
            <h1 class="text-center mb-4">Formulario de Usuarios</h1>
            <form action="">
                <div class="form-group">
                    <label for="fecha_ingreso">Fecha Ingreso:</label>
                    <input type="date" class="form-control" id="fecha_ingreso" name="fecha_ingreso" placeholder="Ingrese de fecha de ingreso">
                </div>
                <div class="form-group">
                    <label for="nombre">Nombre:</label>
                    <input type="text" class="form-control" id="nombre" name="nombre" placeholder="Ingrese su nombre">
                </div>
                <div class="form-group">
                    <label for="salario">Salario:</label>
                    <input type="text" class="form-control" id="salario" name="salario" placeholder="Ingrese su salario">
                </div>
                <button type="submit" name="guardar" class="btn btn-primary btn-block">Guardar</button>
            </form>
            <%
                if (request.getParameter("guardar") != null) {
                    String nombre = request.getParameter("nombre");
                    String salarioString = request.getParameter("salario");
                    Double salario = null;
                    String fechaString = request.getParameter("fecha_ingreso");
                    SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
                    java.util.Date fecha_ingreso = null;
                    String errorMessage = null;
                    
                    if (nombre != null && !nombre.isEmpty() && salarioString != null && !salarioString.isEmpty() && fechaString != null && !fechaString.isEmpty()) {
                        try {
                            salario = Double.parseDouble(salarioString);
                            fecha_ingreso = formatoFecha.parse(fechaString);
                            
                            // Aquí puedes realizar el procesamiento adicional de los datos ingresados
                            // Por ejemplo, guardar en la base de datos, realizar cálculos, etc.
                            
                            Connection con = null;
                            PreparedStatement pstmt = null;
                            
                            try {
                                Class.forName("com.mysql.jdbc.Driver");
                                con = DriverManager.getConnection("jdbc:mysql://localhost/kcrm?user=root&password=");
                                
                                String query = "INSERT INTO Empleado (nombre, salario, fecha_ingreso) VALUES (?, ?, ?)";
                                pstmt = con.prepareStatement(query);
                                pstmt.setString(1, nombre);
                                pstmt.setDouble(2, salario);
                                pstmt.setDate(3, new java.sql.Date(fecha_ingreso.getTime()));
                                
                                int rowsAffected = pstmt.executeUpdate();
                                
                                if (rowsAffected > 0) {
                                    out.println("<div class=\"alert alert-success mt-3\">Registro guardado correctamente.</div>");
                                } else {
                                    out.println("<div class=\"alert alert-danger mt-3\">Error al guardar el registro.</div>");
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                out.println("<div class=\"alert alert-danger mt-3\">Error al guardar el registro.</div>");
                            } finally {
                                if (pstmt != null) {
                                    pstmt.close();
                                }
                                if (con != null) {
                                    con.close();
                                }
                            }
                            
                        } catch (NumberFormatException e) {
                            errorMessage = "El salario debe ser un número válido.";
                        } catch (ParseException e) {
                            errorMessage = "La fecha de ingreso no tiene el formato correcto.";
                        }
                    } else {
                        errorMessage = "Todos los campos son obligatorios.";
                    }
                    
                    if (errorMessage != null) {
                        out.println("<div class=\"alert alert-danger mt-3\">" + errorMessage + "</div>");
                    }
                }
            %>
        </div>
    </div>

    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
