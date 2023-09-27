package controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import model.UserDAO;
import model.UserVO;

@WebServlet(value={"/user/login", "/user/logout", "/user/read", "/user/insert", "/user/update",
				"/user/list.json", "/user/list"})
public class UserController extends HttpServlet {
	private static final long serialVersionUID = 1L;
    UserDAO udao =new UserDAO();   
   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();
		RequestDispatcher dis = request.getRequestDispatcher("/home.jsp");
		HttpSession session=request.getSession();
		switch(request.getServletPath()) {
		case "/user/login":
			String target= request.getParameter("target")==null? "" : request.getParameter("target");
			session.setAttribute("target", target);
			request.setAttribute("pageName", "/user/login.jsp");
			dis.forward(request, response);
			break;
		case "/user/logout":
			session.removeAttribute("user");
			response.sendRedirect("/");
			break;
		case "/user/read":
			UserVO vo =(UserVO)session.getAttribute("user");
			request.setAttribute("vo", udao.read(vo.getUid()));
			request.setAttribute("pageName", "/user/read.jsp");
			dis.forward(request, response);
			break;
		case "/user/insert":
			request.setAttribute("pageName", "/user/insert.jsp");
			dis.forward(request, response);
			break;
		case "/user/list.json": //실행 /user/list.json?page=1&key=uid&query=
			String key = request.getParameter("key");
			String query = request.getParameter("query");
			int page=Integer.parseInt(request.getParameter("page"));
			ArrayList<UserVO> array=udao.list(key, query, page);
			Gson gson=new Gson();
			out.print(gson.toJson(array));
			break;
		case "/user/list":
			request.setAttribute("pageName", "/user/list.jsp");
			dis.forward(request, response);
			break;
		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		HttpSession session=request.getSession();
		String path="/upload/photo/";
		//패스 폴더가 없으면 자동으로 만들어주는 양식
		File mdPath=new File("c:" + path);
		if(!mdPath.exists()) mdPath.mkdir();
		
		switch(request.getServletPath()) {
		case "/user/login":
			String uid=request.getParameter("uid");
			String upass=request.getParameter("upass");
			UserVO user=udao.read(uid);
			int result=0; //아이디가 없는 경우
			if(user.getUid()!=null) {
				if(user.getUpass().equals(upass)) {
					result=1; //성공한경우
					session.setAttribute("user", user);
				}else {
					result=2; //비밀번호 불일치	
				}
			}
			out.print(result);
			break;
		case "/user/insert":
			//폴더생성 마지막에 슬래시 까지 쳐줘야함 안그러면 사진 파일이름일아 합쳐져서 안나옴
			
			//사진저장
			MultipartRequest multi = new MultipartRequest(
					request, "c:" + path, 1024*1024*10, "UTF-8", new DefaultFileRenamePolicy());
			String photo = multi.getFilesystemName("photo")==null ?"":
					path + multi.getFilesystemName("photo");
			//데이타저장
			UserVO vo= new UserVO();
			vo.setUid(multi.getParameter("uid"));
			vo.setUpass(multi.getParameter("upass"));
			vo.setUname(multi.getParameter("uname"));
			vo.setUphone(multi.getParameter("uphone"));
			vo.setAddress1(multi.getParameter("address1"));
			vo.setAddress2(multi.getParameter("address2"));
			vo.setPhoto(photo);
			udao.insert(vo);
			response.sendRedirect("/user/login");
			break;
		case "/user/update":
			multi = new MultipartRequest(
					request, "c:" + path, 1024*1024*10, "UTF-8", new DefaultFileRenamePolicy());
			photo = multi.getFilesystemName("photo")==null ? multi.getParameter("oldPhoto"):
					path + multi.getFilesystemName("photo");
			vo= new UserVO();
			vo.setUid(multi.getParameter("uid"));
			vo.setUpass(multi.getParameter("upass"));
			vo.setUname(multi.getParameter("uname"));
			vo.setUphone(multi.getParameter("uphone"));
			vo.setAddress1(multi.getParameter("address1"));
			vo.setAddress2(multi.getParameter("address2"));
			vo.setPhoto(photo);
			udao.update(vo);
			response.sendRedirect("/user/read");
			break;
		}
	}

}
