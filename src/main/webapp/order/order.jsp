<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
	span{
		width: 100px;
		justify-content: center;
	}
</style>
<div class="row my-5" id="page_order" style="display:none;">
	<div class="col">
		<h1 class="text-center mb-5">주문하기</h1>
		<div id="div_order"></div>
		<h1 class="text-center my-5">주문자정보</h1>
		<form name="frm" class="card p-3">
			<div class="input-group">
				<span class="input-group-text">주문자명</span>
				<input class="form-control" value="${user.uname}">
			</div>
			<div class="input-group">
				<span class="input-group-text">주문자전화</span>
				<input name="uphone" class="form-control" value="${user.uphone}">
			</div>
			<div class="input-group">
				<span class="input-group-text">주문자주소</span>
				<input name="address1" class="form-control" value="${user.address1}">
				<a class="btn btn-dark" id="btn-search">주소검색</a>
			</div>
			<div class="input-group">
				<span class="input-group-text">상세주소</span>
				<input name="address2" class="form-control" value="${user.address2}">
			</div>
			<input name="sum" type="hidden">
			<div class="text-center my-3">
				<button class="btn btn-warning px-5" >주문하기</button>
			</div>
		</form>
	</div>
</div>
<!-- 주문상품 목록 템플릿 -->
<script id="temp_order" type="text/x-handlebars-template">
	<table class="table">
		{{#each .}}
			<tr class="tr" price="{{price}}" qnt="{{qnt}}" gid="{{gid}}">
				<td>{{gid}}</td>
				<td><img src="{{image}}" width="50px"></td>
				<td>{{title}}</td>
				<td>{{sum price 1}}</td>
				<td>{{qnt}}</td>
				<td>{{sum price qnt}}</td>
			</tr>		
		{{/each}}
		<tr>
			<td colspan="6" class="text-end">총합:<span id="orderSum">0원</span></td>
		</tr>
	</table>
</script>
<script>
	//주문하기 버튼 클릭한 경우
	$(frm).on("submit", function(e){
		e.preventDefault();
		if(confirm("위 상품을 주문하실래요?")){
			//구매자정보 등록	
			$.ajax({
				type:"post",
				url:"/purchase/insert",
				data:{uid:"${user.uid}", address1:$(frm.address1).val(), address2:$(frm.address2).val(),
					uphone:$(frm.uphone).val(), sum:$(frm.sum).val()},
				success:function(data){
					const pid=data;
					$("#div_order .tr").each(function(){
						const gid=$(this).attr("gid");
						const qnt=$(this).attr("qnt");
						const price=$(this).attr("price");
						$.ajax({
							type:"post",
							url:"/order/insert",
							data:{pid:pid, gid:gid, price:price, qnt:qnt},
							success:function(){
								//카트에서 상품삭제
								$.ajax({
									type:"get",
									url:"/cart/delete",
									data:{gid:gid},
									success:function(){}
								});
							}
						});
					});
					alert("주문이 완료되었습니다.");
					location.href="/";
				}	
				
			});
		}
	});
	//주소검색 버튼을 누른경우
	$("#btn-search").on("click", function(){
		new daum.Postcode({
			oncomplete: function(data){
				console.log(data);
				if(data.buildingName!=""){
					$(frm.address1).val(data.address+ "/" + data.buildingName);
				}else{
					$(frm.address1).val(data.address);	
				}
			}
		}).open();
	});
	function orderSum(){
		let sum = 0;
		$("#div_order .tr").each(function(){
			const price=$(this).attr("price");
			const qnt=$(this).attr("qnt");		
			sum+=price*qnt;
		});
			$(frm.sum).val(sum);
			$("#orderSum").html(sum.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + "원");
		}
		
	function getOrder(data){
		const temp=Handlebars.compile($("#temp_order").html());
		$("#div_order").html(temp(data));
		orderSum();
	};
</script>