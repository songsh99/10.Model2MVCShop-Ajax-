<%@ page contentType="text/html; charset=euc-kr" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<html>
<head>
<title>상품 목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">

function fncGetProductList(currentPage) {
    $("#currentPage").val(currentPage);

    // 현재 페이지의 "menu" 파라미터 값을 가져옵니다.
    var menu = "${param.menu}";

    // 조건에 따라서 "action" 값을 설정합니다.
    if (menu === "manage") {
        $("form").attr("method", "POST").attr("action", "/product/listProduct?menu=manage").submit();
    } else if (menu === "search") {
        $("form").attr("method", "POST").attr("action", "/product/listProduct?menu=search").submit();
    }
}

$(function() {
	
	$( ".ct_list_pop td:nth-child(11)" ).on("click" , function() {
	    var prodNo = $(this).closest("tr").find(".prod-no").val();
	    var role = $(this).closest("tr").find(".role").val();
	    var menu = "${param.menu}";
	    
	    
	    console.log("role = "+role); // 콘솔에 "안녕하세요, 콘솔!" 메시지를 출력합니다.

	    if (menu === "manage") {
	    	
	    }else if(menu == "search"){
		    if (role === "user") { // "user" 역할인 경우에만 구매 페이지로 이동
		        self.location = "/purchase/addPurchase?prodNo=" + prodNo;
		    } else {
		        // "user"가 아닌 경우에는 아무 동작도 수행하지 않습니다.
		        alert("상품을 구매할 권한이 없습니다.");
		    }
	    }
	});

	 $( "td.ct_btn01:contains('검색')" ).on("click" , function() {
		fncGetProductList(1);
	});
	
	$( ".ct_list_pop td:nth-child(5)" ).on("click" , function() {
	    var prodNo = $(this).closest("tr").find(".prod-no").val();
	    
	    // 어떤 페이지로 이동할지를 조건에 따라 결정합니다.
	    var menu = "${param.menu}"; // "MANAGE" 또는 "SEARCH"를 담을 변수
	    
	    if (menu === "manage") {
	        // "MANAGE" 페이지로 이동하면서 "prodNo" 값을 넘깁니다.
	    	self.location = "/product/updateProduct?prodNo=" + prodNo;
	    } else if (menu === "search") {
	    	$.ajax({
	    		url : "/product/json/getProduct/"+prodNo ,
				method : "GET" ,
				dataType : "json" ,
				headers : {
					"Accept" : "application/json",
					"Content-Type" : "application/json"
				},
				success : function(JSONData , status) {

					//Debug...
					//alert(status);
					//Debug...
					//alert("JSONData : \n"+JSONData);
					
					var displayValue = "<h5>"
												+"상품번호 : "+JSONData.prodNo+"<br/>"
												+"상품명 : "+JSONData.prodName+"<br/>"
												+"상세정보 : "+JSONData.prodDetail+"<br/>"
												+"가격 : "+JSONData.price+" 원<br/>"
												+"상품등록일 : "+JSONData.manuDate+"<br/>"
												+"이미지 파일 : "+JSONData.fileName+"<br/>"
												+"</h3>";
					//Debug...									
					//alert(displayValue);
					
					$("h5").remove();
					$( "#"+prodNo+"" ).html(displayValue);
				}
	    		
	    	});
	        // "SEARCH" 페이지로 이동하면서 "prodNo" 값을 넘깁니다.
	    	//self.location = "/product/getProduct?prodNo=" + prodNo;
	    }
	});
		

	$( ".ct_list_pop td:nth-child(5)" ).css("color" , "red");
	$("h7").css("color" , "red");
					
	$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");;
});	
</script>

</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width:98%; margin-left:10px;">

<form name="detailForm" action="/product/listProduct?menu=${param.menu}" method="post">

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37">
			<img src="/images/ct_ttl_img01.gif" width="15" height="37">
		</td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left:10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					 <c:choose>
				        <c:when test="${'manage' eq param.menu}">
				          <td width="93%" class="ct_ttl01">판매 상품관리</td>
				        </c:when>
				        <c:when test="${'search' eq param.menu}">
				            <td width="93%" class="ct_ttl01">상품 목록조회</td>
				        </c:when>
				    </c:choose>
				</tr>
			</table>
		</td>
		<td width="12" height="37">
			<img src="/images/ct_ttl_img03.gif" width="12" height="37">
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="right">
			<select name="searchCondition" class="ct_input_g" style="width:80px">
		
				<option value="0"  ${ ! empty search.searchCondition && search.searchCondition==0 ? "selected" : "" }>상품번호</option>
				<option value="1"  ${ ! empty search.searchCondition && search.searchCondition==1 ? "selected" : "" }>상품명</option>
				<option value="2"  ${ ! empty search.searchCondition && search.searchCondition==2 ? "selected" : "" }>상품가격</option>
					
			</select>
			
				<input 	type="text" name="searchKeyword"  
				value="${! empty search.searchKeyword ? search.searchKeyword : ""}"  
			 	class="ct_input_g" style="width:200px; height:19px" >	
		</td>

		<td align="right" width="70">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="17" height="23">
						<img src="/images/ct_btnbg01.gif" width="17" height="23">
					</td>
					<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
						검색
					</td>
					<td width="14" height="23"><img src="/images/ct_btnbg03.gif" width="14" height="23"></td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td colspan="11" >
			전체 ${resultPage.totalCount } 건수, 현제${resultPage.currentPage } 페이지
		</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="30">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="100">상품이미지 <br>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">상품명<br>
			<h7>Click[상세보기]</h7>
		</td>
		
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">가격</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">등록일</td>	
		<td class="ct_line02"></td>
		<c:choose>
	                <c:when test="${'manage' eq param.menu}">
	                	<td class="ct_list_b">배송정보</td>
		            </c:when>
	                <c:when test="${'search' eq param.menu}">
						<td class="ct_list_b">상품구매</td>
					</c:when>
            </c:choose>
		
			
		<td class="ct_line02"></td> 
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
	 <c:set var="i" value="0" />
	<c:forEach var="product" items="${list}">
		<c:set var="i" value="${ i+1 }" />
		<tr class="ct_list_pop">
		
			<td align="center">${ i }</td>
			<td></td>
			<td><img src="/images/uploadFiles/${product.fileName}" width="100" alt=""/></td>
			<td></td>
			<td align="center">
			     <c:choose>
	                <c:when test="${'manage' eq param.menu}">
	                    ${product.prodName}
	                    <input type="hidden" class="prod-no" value="${product.prodNo}" />
	                </c:when>
	                <c:when test="${'search' eq param.menu}">
	                    ${product.prodName}
	                    <input type="hidden" class="prod-no" value="${product.prodNo}" />
	                </c:when>
            </c:choose>
			</td>    
			<td></td>
			<td align="center">${product.price} 원</td>
			<td></td>
			<td align="center">${product.regDate}</td>
			<td></td>
			<td align="center">
			 <c:choose>
	                <c:when test="${'manage' eq param.menu}">
	                 <c:set var="trimmedTranCode" value="${fn:trim(purchase.tranCode)}" />
                        <c:choose>
                            <c:when test="${trimmedTranCode eq '1'}">
                                상품준비완료 <a href="/purchase/updateTranCode?tranNo=${purchase.tranNo}">상품준비완료</a>
                            </c:when>
                            <c:when test="${trimmedTranCode eq '2'}">
                                배송중
                            <input type="hidden" class="tranNo" value="${purchase.tranNo}" />
                            </c:when>
                            <c:when test="${trimmedTranCode eq '3'}">
                                배송완료
                            </c:when>
                          
                        </c:choose>
	                </c:when>
	                <c:when test="${'search' eq param.menu}">
	                    
	                    <c:choose>
							<c:when test="${user.role == 'user'}">
									구매
									 <input type="hidden" class="role" value="${user.role}" />
									 <input type="hidden" class="prod-no" value="${product.prodNo}" />
							</c:when>
							<c:otherwise>
									상품구매는 회원만 가능합니다.
							</c:otherwise>
						</c:choose>		
	                </c:when>     
            </c:choose>
			</td>
		</tr>
		<tr>
		<!--  <td colspan="11" bgcolor="D6D7D6" height="1"></td>-->
		<td id="${product.prodNo}" colspan="11" bgcolor="D6D7D6" height="1"></td>
		</tr>
	</c:forEach>

</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="center">
		 <input type="hidden" id="currentPage" name="currentPage" value="0"/>
			<jsp:include page="../common/pageNavigator.jsp">
			<jsp:param name="page" value="Product" />
			</jsp:include>
    	</td>
	</tr>
</table>
<!--  페이지 Navigator 끝 -->
</form>
</div>

</body>
</html>