package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;

@WebServlet("/downloadRawData")
public class DownloadRawDataServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String rawData = request.getParameter("rawData");

        if (rawData == null || rawData.trim().isEmpty()) {
            response.setContentType("text/plain");
            response.getWriter().write("Không có dữ liệu rawData để tải.");
            return;
        }

        // Thiết lập header để tải xuống file .txt
        response.setContentType("text/plain; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"rawData.txt\"");

        try (OutputStream out = response.getOutputStream()) {
            out.write(rawData.getBytes(StandardCharsets.UTF_8));
        }
    }
}
