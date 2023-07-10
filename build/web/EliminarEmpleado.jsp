<%@page import="java.text.*"%>
<%@ page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        
        <title>Formulario de Usuarios</title>
    </head>
    <body>

        <%

            String id = request.getParameter("id");
            Connection con = null;
            ResultSet rs = null;
            Statement sta=null;
            try {
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost/kcrm?user=root&password=");
                sta=con.createStatement();
                sta.executeUpdate("DELETE FROM Empleado WHERE id ='" + id + "' ");
                request.getRequestDispatcher("ListadoEmpleado.jsp").forward(request, response);
                sta.close();
                rs.close();
                con.close();

            } catch (Exception e) {
                e.printStackTrace();
                out.println("<div class=\"alert alert-danger mt-3\">Error al eliminar el registro.</div>");
            }


        %>
    </div>

