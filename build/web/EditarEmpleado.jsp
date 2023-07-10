<%@ page import="java.text.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
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
    <title>Editar Empleado</title>
</head>
<body>
    <div class="container-center">
        <div class="form-container">
            <h1 class="text-center mb-4">Editar Empleado</h1>
            <% 
            String id = request.getParameter("id");

            if (id != null && !id.isEmpty()) {
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost/kcrm?user=root&password=");
                    PreparedStatement pstmt = con.prepareStatement("SELECT nombre, salario, fecha_ingreso FROM Empleado WHERE id = ?");
                    pstmt.setInt(1, Integer.parseInt(id));
                    ResultSet rs = pstmt.executeQuery();

                    if (rs.next()) {
                        String nombre = rs.getString("nombre");
                        double salario = rs.getDouble("salario");
                        String fecha_ingreso = rs.getString("fecha_ingreso");
            %>
            <form action="">
                <div class="form-group">
                    <label for="id">ID:</label>
                    <input type="number" class="form-control" id="id" name="id" placeholder="Ingrese el ID del empleado a editar" value="<%= id %>" readonly>
                </div>
                <div class="form-group">
                    <label for="fecha_ingreso">Fecha Ingreso:</label>
                    <input type="date" class="form-control" id="fecha_ingreso" name="fecha_ingreso" placeholder="Ingrese la fecha de ingreso" value="<%= fecha_ingreso %>">
                </div>
                <div class="form-group">
                    <label for="nombre">Nombre:</label>
                    <input type="text" class="form-control" id="nombre" name="nombre" placeholder="Ingrese el nombre" value="<%= nombre %>">
                </div>
                <div class="form-group">
                    <label for="salario">Salario:</label>
                    <input type="text" class="form-control" id="salario" name="salario" placeholder="Ingrese el salario" value="<%= salario %>">
                </div>
                <button type="submit" name="Editar" class="btn btn-primary btn-block">Guardar</button>
            </form>
            <%    
                    } else {
                        out.println("<div class=\"alert alert-danger mt-3\">No se encontró ningún empleado con el ID proporcionado.</div>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<div class=\"alert alert-danger mt-3\">Error al obtener los datos del empleado.</div>");
                }
            } else {
                out.println("<div class=\"alert alert-danger mt-3\">No se proporcionó ningún ID para editar.</div>");
            }

            if (request.getParameter("Editar") != null) {
                String nombreNuevo = request.getParameter("nombre");
                String salarioNuevoString = request.getParameter("salario");
                String fechaIngresoNuevoString = request.getParameter("fecha_ingreso");

                if (nombreNuevo != null && !nombreNuevo.isEmpty() && salarioNuevoString != null && !salarioNuevoString.isEmpty() && fechaIngresoNuevoString != null && !fechaIngresoNuevoString.isEmpty()) {
                    try {
                        double salarioNuevo = Double.parseDouble(salarioNuevoString);
                        SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
                        java.util.Date fechaIngresoNuevo = formatoFecha.parse(fechaIngresoNuevoString);

                        Class.forName("com.mysql.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost/kcrm?user=root&password=");

                        String updateQuery = "UPDATE Empleado SET nombre = ?, salario = ?, fecha_ingreso = ? WHERE id = ?";
                        PreparedStatement pstmt = con.prepareStatement(updateQuery);
                        pstmt.setString(1, nombreNuevo);
                        pstmt.setDouble(2, salarioNuevo);
                        pstmt.setDate(3, new java.sql.Date(fechaIngresoNuevo.getTime()));
                        pstmt.setInt(4, Integer.parseInt(id));
                        int rowsAffected = pstmt.executeUpdate();

                        if (rowsAffected > 0) {
                            out.println("<div class=\"alert alert-success mt-3\">El empleado ha sido actualizado exitosamente.</div>");
                        } else {
                            out.println("<div class=\"alert alert-danger mt-3\">Error al actualizar el empleado.</div>");
                        }
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        out.println("<div class=\"alert alert-danger mt-3\">Error al actualizar el empleado.</div>");
                    }
                } else {
                    out.println("<div class=\"alert alert-danger mt-3\">Todos los campos son obligatorios.</div>");
                }
            }
            %>
        </div>
    </div>

    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
