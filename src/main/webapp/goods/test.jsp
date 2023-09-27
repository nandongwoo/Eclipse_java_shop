<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="row my-5">
	<div class="col">
		<h1 class="text-center mb-3">장바구니</h1>
		<div id="div_cart"></div>
	</div>
</div>
<!-- 카트목록 템플릿 -->
<script id="temp_cart" type="text/x-handlebars-template">
	<table class="table">
		{{#each .}}
			<tr class="total" sum="{{sum}}">
				<td class="gid">{{gid}}</td>
				<td><img src="{{image}}" width="50px"></td>
				<td>{{title}}</td>
				<td>{{sum price 1}}</td>
				<td>
					<input class="qnt" value="{{qnt}}" size=5 oninput="isNumber(this)">&nbsp;
					<button class="btn btn-white btn-sm">수정</button>
				</td>
				<td>{{total sum}}</td>
					<td><button class="btn btn-dark btn-sm" gid="{{gid}}">삭제</button></td>
			</tr>
		{{/each}}
		<tr>
			<td colspan="7" class="text-end">
			<h5>총합계:<span id="total">0</span></h5>
			</td>
		</tr>
	</table>
</script>
<script>
	Handlebars.registerHelper("total", function(sum){
		const total+=sum;
		return total.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + "원";
	});
</script>
<script>
	getList();
	
	getTotal();
	function getTotal(){
		let total=0;
		$("#div_cart .total").each(function(){
			const sum=$(this).attr("sum");
			console.log(sum);
			total+=sum;
		})
		$("#total").html();
	};
	
	
	$("#div_cart").on("click", ".btn-white", function(){
		const row=$(this).parent().parent();
		const gid=row.find(".gid").text();
		const qnt=row.find(".qnt").val();
		if(confirm(gid + "상품의 수량을" + qnt+ "로 변경하실래요?")){
			$.ajax({
				type:"get",
				url:"/cart/update",
				data:{gid:gid, qnt:qnt},
				success:function(){
					getList();
				}
			});
		}
	})
	
	//숫자만
	function isNumber(item){
		item.value = item.value.replace(/[^0-9]/g, '');
	}
	
	$("#div_cart").on("click", ".btn-dark", function(){
		const gid=$(this).attr("gid");
		if(confirm(gid + "번 상품을 삭제하실래요?")){
			$.ajax({
				type:"get",
				url:"/cart/delete",
				data:{gid:gid},
				success:function(){
					getList();
				}
			})
		}
	});
	function getList(){
		$.ajax({
			type:"get",
			url:"/cart/list.json",
			dataType:"json",
			success:function(data){
				const temp=Handlebars.compile($("#temp_cart").html());
				$("#div_cart").html(temp(data));
			}
		});	
	}
</script>