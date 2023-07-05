<%--
    Document   : ListadoSolicitudUsuario
    Created on : 3/07/2023, 08:07:50 PM
    Author     : midac
--%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Listado de Solicitudes de los Empleados</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .table {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="text-center">Listado de Solicitudes de los Empleados</h1>
        <div class="table-responsive">
            <table class="table table-bordered table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th>Nombre</th>
                        <th>Sueldo</th>
                        <th>Código</th>
                        <th>Descripción</th>
                        <th>Resumen</th>
                    </tr>
                </thead>
                <tbody>
                    <%  
                        int totalRegistrosSolicitudes = 0; // Valor predeterminado
                        int registrosPorPaginaSolicitudes = 4; // Valor predeterminado (cambiar según tus necesidades)
                        int paginaActualSolicitudes = 1; // Valor predeterminado (cambiar según tus necesidades)

                        try {
                            Connection con = null;
                            Statement sta = null;
                            ResultSet rs = null;

                            Class.forName("com.mysql.jdbc.Driver");
                            con = DriverManager.getConnection("jdbc:mysql://localhost/kcrm?user=root&password=");

                            String queryCount = "SELECT COUNT(*) FROM Solicitud";
                            sta = con.createStatement();
                            rs = sta.executeQuery(queryCount);

                            if (rs.next()) {
                                totalRegistrosSolicitudes = rs.getInt(1);
                            }

                            sta.close();
                            rs.close();

                            // Resto del código para la paginación y consulta de datos
                            // Obtiene la página actual de los parámetros de la URL
                            String paginaSolicitudes = request.getParameter("paginaSolicitudes");
                            if (paginaSolicitudes != null) {
                                paginaActualSolicitudes = Integer.parseInt(paginaSolicitudes);
                            }

                            // Calcula el índice inicial y final de los registros a mostrar en la página actual
                            int indiceInicial = (paginaActualSolicitudes - 1) * registrosPorPaginaSolicitudes;
                            int indiceFinal = indiceInicial + registrosPorPaginaSolicitudes;

                            String queryData = "SELECT E.nombre, E.salario, S.codigo, S.descripcion, S.resumen "
                                    + "FROM Empleado E LEFT JOIN Solicitud S ON E.id = S.id_empleado "
                                    + "LIMIT " + indiceInicial + ", " + registrosPorPaginaSolicitudes;
                            sta = con.createStatement();
                            rs = sta.executeQuery(queryData);

                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString("nombre")%></td>
                        <td><%= rs.getString("salario")%></td>
                        <td><%= rs.getString("codigo")%></td>
                        <td><%= rs.getString("descripcion")%></td>
                        <td><%= rs.getString("resumen")%></td>
                    </tr>
                    <%
                            }

                            sta.close();
                            rs.close();
                            con.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </tbody>
            </table>
        </div>
        <ul class="pagination justify-content-center">
            <% for (int i = 1; i <= Math.ceil((double) totalRegistrosSolicitudes / registrosPorPaginaSolicitudes); i++) { %>
            <li class="page-item <% if (i == paginaActualSolicitudes) { %>active<% } %>">
                <a class="page-link" href="?paginaSolicitudes=<%= i %>"><%= i %></a>
            </li>
            <% } %>
        </ul>
    </div>

    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
