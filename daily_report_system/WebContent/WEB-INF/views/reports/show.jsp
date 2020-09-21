<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:import url="/WEB-INF/views/layout/app.jsp">
    <c:param name="content">
        <c:choose>
            <c:when test="${report != null}">
                <h2>日報　詳細ページ</h2>
                <form method="POST" action="<c:url value='/reports/approval' />" onsubmit="change()">
                <table>
                    <tbody>
                        <tr>
                            <th>氏名</th>
                            <td><c:out value="${report.employee.name}" /></td>
                        </tr>
                        <tr>
                            <th>日付</th>
                            <td><fmt:formatDate value="${report.report_date}" pattern="yyyy-MM-dd" /></td>
                        </tr>
                        <tr>
                            <th>内容</th>
                            <td>
                                <pre><c:out value="${report.content}" /></pre>
                            </td>
                        </tr>
                        <tr>
                            <th>登録日時</th>
                            <td>
                                <fmt:formatDate value="${report.created_at}" pattern="yyyy-MM-dd HH:mm:ss" />
                            </td>
                        </tr>
                        <tr>
                            <th>更新日時</th>
                            <td>
                                <fmt:formatDate value="${report.updated_at}" pattern="yyyy-MM-dd HH:mm:ss" />
                            </td>
                        </tr>
                        <tr>
                            <th>上長承認</th>
                            <td>
                            <input type="hidden" id="approval_val" name="approval_val" value="${report.approval}" />
                            <input type="hidden" id="login_id" value="${code}" />
                            <input type="hidden" name="_token" value="${_token}" />
                            <input type="submit" id="btnConfirm" value="" />
                            <script type="text/javascript">
                            window.onload = function() {
                                var aval = document.getElementById("approval_val").value;
                                var loginId = document.getElementById("login_id").value;
                                var button = document.getElementById("btnConfirm");

                                if (aval=="1") {
                                    button.value = "確認済";
                                } else {
                                    button.value = "未確認";
                                }
                             //alert(loginId);
                             // 0文字目から1文字分を指定
                               var result = loginId.substr( 0, 1 );
                                if (result=="b") {
                                    button.disabled = true;
                                }


                            };

                            function change()
                            {
                                var aval = document.getElementById("approval_val");

                                if ( aval.value == "0" ){
                                 aval.value = "1";
                                }else{
                                    aval.value = "0";
                                }
                                alert(avel.value);
                            }

                            </script>
                             </td>
                        </tr>
                    </tbody>
                </table>
                </form>
                <c:if test="${sessionScope.login_employee.id == report.employee.id}">
                    <p><a href="<c:url value="/reports/edit?id=${report.id}" />">この日報を編集する</a></p>
                </c:if>
            </c:when>
            <c:otherwise>
                <h2>お探しのデータは見つかりませんでした。</h2>
            </c:otherwise>
        </c:choose>

        <p><a href="<c:url value="/reports/index" />">一覧に戻る</a></p>
    </c:param>
</c:import>