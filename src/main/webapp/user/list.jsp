<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
	.phone, .address {
		font-size:12px;
	}
</style>
<div class="row my-5">
	<div class="col">
		<h1 class="text-center mb-5">회원목록</h1>
		<div class="row">
			<form class="col-6" name="frm">
				<div class="input-group">
					<select class="form-select" name="key">
						<option value="uid">아이디</option>
						<option value="uname" selected>회원이름</option>
						<option value="address1">회원주소</option>
						<option value="uphone">회원전화</option>
					</select>&nbsp;
					<input class="form-control" placeholder="검색어" name="query">
					<input type="submit" value="검색" class="btn btn-primary">
				</div>
			</form>
		</div>
		<hr>
		<div id="div_user" class="row"></div>
	</div>
</div>
<!-- 회원목록 템플릿 -->
<script id="temp_user" type="x-handlebars-template">
	{{#each .}}
	<div class="col-6 col-md-4 col-lg-2">
		<div class="card mb-3 p-2">
			<img src="{{photo photo}}" class="card-img-top">
			<hr>
			<div class="card-body">
				<div><a href="/user/read?uid={{uid}}">{{uname}} ({{uid}})</a></div>
				<div class="ellipsis address">{{address1}} {{address2}}</div>
				<div class="ellipsis uphone">{{uphone}}</div>
			</div>
		</div>
	</div>
	{{/each}}
</script>
<script>
	Handlebars.registerHelper("photo", function(photo){
		if(!photo){
			return "http://via.placeholder.com/100x100";
		}else{
			return photo;
		}
	});
</script>
<script>
	let page=1;
	let query=$(frm.query).val();
	let key=$(frm.key).val();
	
	$(frm).on("submit", function(e){
		e.preventDefault();
		query=$(frm.query).val();
		key=$(frm.key).val();
		getList();
	});
	
	getList();
	function getList(){
		$.ajax({
			type:"get",
			url:"/user/list.json",
			data:{key:key,query:query, page:page},
			dataType:"json",
			success:function(data){
				const temp=Handlebars.compile($("#temp_user").html());
				$("#div_user").html(temp(data));
			}
		});
	}
</script>