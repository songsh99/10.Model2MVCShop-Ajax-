<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page pageEncoding="EUC-KR"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<title>���� �����ȸ</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
	
	function fncGetPurchaseList(currentPage) {
		//document.getElementById("currentPage").value = currentPage;
		$("#currentPage").val(currentPage)
	   	//document.detailForm.submit();
		$("form").attr("method" , "POST").attr("action" , "/purchase/listPurchase").submit();
	}
	
	$(function(){
	
		$( ".ct_list_pop td:nth-child(1)" ).on("click", function() {
		  // Ŭ���� td ����� ���� ���� ��� �߿� input ��Ҹ� ����
		  var inputElement = $(this).find("input");
		  
		  // input ����� ���� ������
		  var tranNoValue = inputElement.val();
		 
		  // ���� �ֿܼ� ����ϰų� �ʿ��� �۾��� ����
		  console.log("tranNo ��: " + tranNoValue);
		  
		  self.location = "/purchase/getPurchase?tranNo=" + tranNoValue;
		});

		 $("span.ct_list_pop:contains('���ǵ����� Ŭ��')").on("click", function() {
			    var inputElement = $(this).find("input");
			    var tranNoValue = inputElement.val();
			    console.log("tranNo ��: " + tranNoValue);
			    self.location = "/purchase/updateTranCode?tranNo=" + tranNoValue + "&tranCode=3";
			  });


		$( ".ct_list_top td:nth-child(1)" ).on("click",function(){
			self.location ="/user/getUser?userId="+$(this).text().trim();
		});
		
// 		$( ".ct_list_pop td:nth-child(11)" ).on("click",function(){
// 			//self.location ="/purchase/updateTranCode?tranNo="+$(this).text().trim();
// 			self.location ="/purchase/updateTranCode?tranNo=10065";
// 		});
	});
	
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width: 98%; margin-left: 10px;">

<form name="detailForm" action="/purchase/listPurchase" method="post">

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37"><img src="/images/ct_ttl_img01.gif"width="15" height="37"></td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left: 10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">���� �����ȸ</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37"><img src="/images/ct_ttl_img03.gif"	width="12" height="37"></td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top: 10px;">

	<tr class="ct_list_top">
		<td colspan="11" >
			<c:forEach var="purchase" items="${list}" varStatus="loop">
			    <c:if test="${loop.index == 0}">
			        ������ :�� ${purchase.buyer.userId} ��
			    </c:if>
			</c:forEach>
		</td><tr>
		<td colspan="11" >
			��ü  ${resultPage.totalCount } �Ǽ�, ���� ${resultPage.currentPage}  ������
		</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="50">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">��ǰ�̹���</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">�����ڸ�</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">����ó</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">��������</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">�������</td>
	</tr>
	
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
	
	<c:set var="i" value="0" />
		
		<c:forEach var="purchase" items="${list}">
	<c:set var="i" value="${ i+1 }" />
		<tr class="ct_list_pop">
			<td align="center" >
				 ${ i } 
				<input type="hidden" class="tranNo" value="${purchase.tranNo}" />	
			</td>
			<td></td>
			<td align="center">
				${product.prodName}
				<input type="hidden" class="userId" value="${purchase.purchaseProd.prodName}" />
			</td>
			<td></td>
			<td align="center">${purchase.receiverName}</td>
			<td></td>
			<td align="center">${purchase.receiverPhone}</td>
			<td></td>
			 <td align="center">
                        <c:set var="trimmedTranCode" value="${fn:trim(purchase.tranCode)}" />
                        <c:choose>
                            <c:when test="${trimmedTranCode eq '1'}">
                                ���ſϷ�
                            </c:when>
                            <c:when test="${trimmedTranCode eq '2'}">
                                �����
                            </c:when>
                            <c:when test="${trimmedTranCode eq '3'}">
                                ��ۿϷ�
                            </c:when>
                           
                        </c:choose>
             </td>
			<td></td>
			 <td align="center">
			 <span class="ct_list_pop">
				  <c:set var="trimmedTranCode" value="${fn:trim(purchase.tranCode)}" />
				  <c:choose>
				    <c:when test="${trimmedTranCode eq '1'}">
				      ��ǰ�غ���
				    </c:when>
				    <c:when test="${trimmedTranCode eq '2'}">
				      ���ǵ����� Ŭ��
				      <input type="hidden" class="tranNo" value="${purchase.tranNo}" />
				      <!--a href="/purchase/updateTranCode?tranNo=${purchase.tranNo}&tranCode=3">���ǵ����� Ŭ��</a-->
				    </c:when>
				    <c:when test="${trimmedTranCode eq '3'}">
				      ���ſϷ��� ��ǰ
				    </c:when>
				  </c:choose>
				</span>
             </td>
		</tr>
		<tr>
			<td colspan="11" bgcolor="D6D7D6" height="1"></td>
		</tr>
	</c:forEach>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="center">
		 <input type="hidden" id="currentPage" name="currentPage" value="0"/>
			<jsp:include page="../common/pageNavigator.jsp">
			<jsp:param name="page" value="Purchase" />
			</jsp:include>
    	</td>
	</tr>
</table>
<!--  ������ Navigator �� -->
</form>

</div>

</body>
</html>