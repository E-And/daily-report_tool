package controllers.reports;

import java.io.IOException;
import java.util.List;

import javax.persistence.EntityManager;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import models.Report;
import models.validators.ReportValidator;
import utils.DBUtil;

/**
 * Servlet implementation class ReportsApprovalServlet
 */
@WebServlet("/reports/approval")
public class ReportsApprovalServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReportsApprovalServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub

        String _token = (String)request.getParameter("_token");
        if(_token != null && _token.equals(request.getSession().getId())) {
            EntityManager em = DBUtil.createEntityManager();
            // 更新をかけるReportsテーブルのカラム"report_id"と一致するデータを取得している
            Report r = em.find(Report.class, (Integer)(request.getSession().getAttribute("report_id")));
            // 画面から渡された項目名"approval_val" 値には文字列型で”1”または"0"が入るので、Integer型に変換
            Integer itApproval = new Integer(request.getParameter("approval_val"));
            // Reportsテーブルのカラム"approval"に画面から渡された値をint型に変換して設定
            r.setApproval(itApproval.intValue());

            List<String> errors = ReportValidator.validate(r);
            if(errors.size() > 0) {
                em.close();

                request.setAttribute("_token", request.getSession().getId());
                request.setAttribute("report", r);
                request.setAttribute("errors", errors);

                RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/reports/view.jsp");
                rd.forward(request, response);
            } else {
                em.getTransaction().begin();
                em.getTransaction().commit();
                em.close();
                request.getSession().setAttribute("flush", "更新が完了しました。");

                request.getSession().removeAttribute("report_id");
                request.setAttribute("report", r);
                request.setAttribute("_token", request.getSession().getId());
                request.getSession().setAttribute("report_id", r.getId());

                RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/reports/show.jsp");
                rd.forward(request, response);
            }
        }

    }

}
