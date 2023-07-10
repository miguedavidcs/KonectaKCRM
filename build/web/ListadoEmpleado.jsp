<%@ page import="java.sql.*" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
        <!-- Latest compiled and minified CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
        <!-- jQuery library -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <!-- Popper JS -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
        <!-- Latest compiled JavaScript -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
        <style>
            .mi-div {
                width: 1300px;
                margin: 0 auto; 
                width: 500px;
                padding: 50px;
                
            }
        </style>
    </head>
    <body>
        <div class="text-center">
            <a href="index.jsp" class="btn btn-primary">Ir a Index</a>
        </div>

        <h1>Listado de Empleados</h1>
        <%
            int totalRegistrosEmpleados = 0; // Valor predeterminado
            int registrosPorPaginaEmpleados = 2; // Valor predeterminado (cambiar según tus necesidades)
            int paginaActualEmpleados = 1; // Valor predeterminado (cambiar según tus necesidades)

            try {
                Connection con = null;
                Statement sta = null;
                ResultSet rs = null;

                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost/kcrm?user=root&password=");

                String queryCount = "SELECT COUNT(*) FROM Empleado";
                sta = con.createStatement();
                rs = sta.executeQuery(queryCount);

                if (rs.next()) {
                    totalRegistrosEmpleados = rs.getInt(1);
                }

                sta.close();
                rs.close();

                // Resto del código para la paginación y consulta de datos
                // Obtiene la página actual de los parámetros de la URL
                String paginaEmpleados = request.getParameter("paginaEmpleados");
                if (paginaEmpleados != null) {
                    paginaActualEmpleados = Integer.parseInt(paginaEmpleados);
                }

                // Calcula el índice inicial y final de los registros a mostrar en la página actual
                int indiceInicial = (paginaActualEmpleados - 1) * registrosPorPaginaEmpleados;
                int indiceFinal = indiceInicial + registrosPorPaginaEmpleados;

                String queryData = "SELECT nombre, salario,id FROM Empleado LIMIT " + indiceInicial + ", " + registrosPorPaginaEmpleados;
                sta = con.createStatement();
                rs = sta.executeQuery(queryData);

        %>
        <div class="mi-div table-responsive d-flex justify-content-center align-items-center">
            <table class="table table-bordered table-striped">
                <thead class="thead-dark" >
                    <tr height="100px">
                        <th colspan="2">Tabla de Usuarios</th>
                        <th><a href="insertarEmpleado.jsp"><img src="imagen/plus.png"></th></a>
                    </tr>
                    <tr>
                        <th>Nombre</th>
                        <th>Sueldo</th>
                        <th>Accion</th>
                    </tr>
                </thead>
                <%            while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("nombre")%></td>
                    <td><%= rs.getString("salario")%></td>
                    <td>
                        <a href="EditarEmpleado.jsp?id=<%=rs.getString("id")%>">
                        <img src="imagen/Edita.png" width="30" height="30"> </a>
                        <a href="EliminarEmpleado.jsp?id=<%=rs.getString("id")%>">
                        <img src="imagen/resta.png" width="30" height="30">
                        </a>
                        </td>
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
            </table>
        </div>
        <br>
        <ul class="pagination justify-content-center">
            <% for (int i = 1; i <= Math.ceil((double) totalRegistrosEmpleados / registrosPorPaginaEmpleados); i++) { %>
            <li class="page-item <% if (i == paginaActualEmpleados) { %>active<% }%>">
                <a class="page-link" href="?paginaEmpleados=<%= i%>"><%= i%></a>
            </li>
            <% }%>
        </ul>




    </body>
</html>
