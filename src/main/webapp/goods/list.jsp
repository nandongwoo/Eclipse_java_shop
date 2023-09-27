<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="row my-5">
	<div class="col">
		<h1 class="text-center">상품목록</h1>
		<div class="row justify-content-end">
			<div class="col">
				<a href="/goods/insert">
					<button class="btn btn-dark">상품등록</button>
				</a>
			</div>
			<form name="frm" class="col-4">
				<div class="input-group mb-3">
					<input name="query" class="form-control" value="">
					<button class="btn btn-dark">검색</button>
				</div>	 
			</form>
		</div>
		<div id="div_goods"></div>
		<div id="pagination" class="pagination justify-content-center"></div>
	</div>
</div>

<!-- 상품목록 템플릿 -->
<script id="temp_goods" type="text/x-handlebars-template">
	<table class="table">
	{{#each .}}
		<tr>
			<td class="gid"><a href="/goods/update?gid={{gid}}">{{gid}}</a></td>
			<td><img class="image" src="{{image}}" width="50px"></td>
			<td><div class= "title ellipsis">{{title}}</div></td>
			<td>{{fmtPrice price}}</td>
			<td>{{maker}}</td>
			<td><button class="btn btn-dark btn-sm" gid="{{gid}}" image="{{image}}">삭제</button></td>
		</tr>
	{{/each}}
	</table>
</script>
<script>
	Handlebars.registerHelper("fmtPrice", function(price){
		return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + "원";
	});
</script>
<script>
	let page=1;
	let query="";
	
	//삭제버튼을 누른경우
	$("#div_goods").on("click", ".btn-dark", function(){
		const image=$(this).attr("image");
		const gid=$(this).attr("gid");
		if(confirm("해당상품을 삭제하실래요?")){
			$.ajax({
				type:"post",
				url:"/goods/delete",
				data:{gid:gid, image:image},
				success:function(){// 리턴타입없으니까 그냥 쓴다.
					alert("상품삭제 완료");
					getTotal();
				}
			});
		}
	});
	
	getTotal();
	function getTotal(){
		$.ajax({
			type:"get",
			url:"/goods/total",
			data:{query:query},
			success:function(data){
				const totalPages=Math.ceil(data/6);
				if(totalPages==0){
					alert("검색내용이 존재하지 않습니다.");
					query="";
					getTotal();
				}else{
					$("#pagination").twbsPagination("changeTotalPages", totalPages, 1);
				}
			}
		});	
	}
	
	$(frm).on("submit", function(e){
		e.preventDefault();
		query=$(frm.query).val();
		getTotal();
	});
	
	getList();
	function getList (){
		$.ajax({
			type:"get",
			url:"/goods/list.json",
			data:{page:page, query:query},
			dataType:"json",
			success:function(data){
				console.log(data);
				const temp=Handlebars.compile($("#temp_goods").html());
				$("#div_goods").html(temp(data));
			}
		});
	}
	$('#pagination').twbsPagination({
	    totalPages:10,	// 총 페이지 번호 수
	    visiblePages: 5,	// 하단에서 한번에 보여지는 페이지 번호 수
	    startPage : 1, // 시작시 표시되는 현재 페이지
	    initiateStartPageClick: false,	// 플러그인이 시작시 페이지 버튼 클릭 여부 (default : true)
	    first : '<<',	// 페이지네이션 버튼중 처음으로 돌아가는 버튼에 쓰여 있는 텍스트
	    prev : '<',	// 이전 페이지 버튼에 쓰여있는 텍스트
	    next : '>',	// 다음 페이지 버튼에 쓰여있는 텍스트
	    last : '>>',	// 페이지네이션 버튼중 마지막으로 가는 버튼에 쓰여있는 텍스트
	    onPageClick: function (event, curPage) {
	    	page=curPage;
	    	getList();
	    }
	});
</script>