package model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

public class ReviewDAO {
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	//리뷰목록
	public ArrayList<ReviewVO> list(String gid){
		ArrayList<ReviewVO> array=new ArrayList<ReviewVO>();
		try {
			String sql="select * from view_reviews where gid=? order by rid desc";
			PreparedStatement ps=Database.CON.prepareStatement(sql);
			ps.setString(1, gid);
			ResultSet rs=ps.executeQuery();
			while(rs.next()) {
				ReviewVO vo=new ReviewVO();
				vo.setRid(rs.getInt("rid"));
				vo.setGid(rs.getString("gid"));
				vo.setUid(rs.getString("uid"));
				vo.setContent(rs.getString("content"));
				vo.setRevDate(sdf.format(rs.getTimestamp("revDate")));
				vo.setPhoto(rs.getString("photo"));
				array.add(vo);
			}
		}catch(Exception e) {
			System.out.println("리뷰목록:" + e.toString());
		}
		return array;
	}
	
	//리뷰등록
	public void insert(ReviewVO vo) {
		try {
			String sql="insert into reviews(gid, uid, content) values(?,?,?)";
			PreparedStatement ps=Database.CON.prepareStatement(sql);
			ps.setString(1, vo.getGid());
			ps.setString(2, vo.getUid());
			ps.setString(3, vo.getContent());
			ps.execute();
		}catch(Exception e) {
			System.out.println("리뷰등록:" + e.toString());
		}
	}
}