<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.text.*"%>
<%@ page import="java.sql.*" %>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONObject"%>

<%
    // Establecer la conexión con la base de datos
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost/kcrm?user=root&password=");

        // Consultar los empleados
        String query = "SELECT id, nombre FROM empleado";
        pstmt = con.prepareStatement(query);
        rs = pstmt.executeQuery();

        // Crear una lista de empleados
        JSONArray employees = new JSONArray();

        while (rs.next()) {
            int id = rs.getInt("id");
            String nombre = rs.getString("nombre");

            // Crear un objeto JSON para cada empleado
            JSONObject employee = new JSONObject();
            employee.put("id", id);
            employee.put("nombre", nombre);

            // Agregar el objeto JSON a la lista de empleados
            employees.add(employee);
        }

        // Crear un objeto JSON que contiene la lista de empleados
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("success", true);
        jsonResponse.put("data", employees);

        // Establecer la respuesta como JSON
        out.println(jsonResponse.toJSONString());
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();

        // Crear un objeto JSON de error en caso de excepción
        JSONObject errorResponse = new JSONObject();
        errorResponse.put("success", false);
        errorResponse.put("message", "Error al obtener los empleados");

        // Establecer la respuesta de error como JSON
        out.println(errorResponse.toJSONString());
    } finally {
        // Cerrar las conexiones y liberar los recursos
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        if (con != null) {
            try {
                con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>
