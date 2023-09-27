package model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

public class PurchaseDAO {
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	//구매상태변경
	public void update(String pid, int status) {
		try {
			String sql="update purchase set status=? where pid=?";
			PreparedStatement ps = Database.CON.prepareStatement(sql);
			ps.setInt(1, status);
			ps.setString(2, pid);
			ps.execute();
		}catch(Exception e) {
			System.out.println("구매상태변경:" +e.toString());
		}
	}
	//구매한 상품목록
	public ArrayList<OrderVO> list(String pid){
		ArrayList<OrderVO> array=new ArrayList<>();
		try {
			String sql="select * from view_orders where pid=?";
			PreparedStatement ps =Database.CON.prepareStatement(sql);
			ps.setString(1, pid);
			ResultSet rs =ps.executeQuery();
			while(rs.next()) {
				OrderVO vo = new OrderVO();
				vo.setOid(rs.getInt("oid"));
				vo.setPid(rs.getString("pid"));
				vo.setGid(rs.getString("gid"));
				vo.setPrice(rs.getInt("price"));
				vo.setQnt(rs.getInt("qnt"));
				vo.setTitle(rs.getString("title"));
				vo.setImage(rs.getString("image"));
				array.add(vo);
			}
		}catch(Exception e) {
			System.out.println("구매상품목록:" + e.toString());
		}
		return array;
	}
	//구매에정
	public PurchaseVO read(String pid) {
		PurchaseVO vo= new PurchaseVO();
		try {
			String sql="select * from view_purchase where pid=?";
			PreparedStatement ps =Database.CON.prepareStatement(sql);
			ps.setString(1, pid);
			ResultSet rs =ps.executeQuery();
			if(rs.next()) {
				vo.setPid(rs.getString("pid"));
				vo.setUid(rs.getString("uid"));
				vo.setUname(rs.getString("uname"));
				vo.setAddress1(rs.getString("raddress1"));
				vo.setAddress2(rs.getString("raddress2"));
				vo.setUphone(rs.getString("rphone"));
				vo.setPurDate(sdf.format(rs.getTimestamp("purdate")));
				vo.setStatus(rs.getInt("status"));
				vo.setPurSum(rs.getInt("pursum"));
			}
		}catch(Exception e) {
			System.out.println("구매정보:" + e.toString());
		}
		return vo;
	}
	//검색개수
	public int total (String query, String key) {
		int total=0;
		try {
			String sql="select count(*) cnt from view_purchase where " + key + " like ?";
			PreparedStatement ps = Database.CON.prepareStatement(sql);
			ps.setString(1, "%" + query + "%");
			ResultSet rs =ps.executeQuery();
			if(rs.next()) total = rs.getInt("cnt");
		}catch(Exception e) {
			System.out.println("구매검색개수:" + e.toString());
		}
		return total;
	}
	
	//구매목록
	public ArrayList<PurchaseVO> list(String key, String query, int page){
		ArrayList<PurchaseVO> array =new ArrayList<>();
		try {
			String sql="select * from view_purchase where " + key + " like ? order by purDate desc limit ?,5";
			PreparedStatement ps =Database.CON.prepareStatement(sql);
			ps.setString(1, "%" + query + "%");
			ps.setInt(2, (page-1)*5);
			ResultSet rs =ps.executeQuery();
			while(rs.next()) {
				PurchaseVO vo= new PurchaseVO();
				vo.setPid(rs.getString("pid"));
				vo.setUid(rs.getString("uid"));
				vo.setUname(rs.getString("uname"));
				vo.setAddress1(rs.getString("raddress1"));
				vo.setAddress2(rs.getString("raddress2"));
				vo.setUphone(rs.getString("rphone"));
				vo.setPurDate(sdf.format(rs.getTimestamp("purdate")));
				vo.setStatus(rs.getInt("status"));
				vo.setPurSum(rs.getInt("pursum"));
				array.add(vo);
			}
		}catch(Exception e) {
			System.out.println("구매목록:" + e.toString());
		}
		return array;
	}
	//주문상품등록
	public void insert(OrderVO vo) {
		try {
			String sql="insert into orders(pid, gid, price, qnt) values(?,?,?,?)";
			PreparedStatement ps = Database.CON.prepareStatement(sql);
			ps.setString(1, vo.getPid());
			ps.setString(2, vo.getGid());
			ps.setInt(3, vo.getPrice());
			ps.setInt(4, vo.getQnt());
			ps.execute();
		}catch(Exception e) {
			System.out.println("주문상품등록:" +e.toString());
		}
	}
	//구매(주문)등록
	public void insert(PurchaseVO vo) {
		try {
			String sql="insert into purchase(pid, uid, raddress1, raddress2, rphone, purSum) values(?,?,?,?,?,?)";
			PreparedStatement ps = Database.CON.prepareStatement(sql);
			ps.setString(1, vo.getPid());
			ps.setString(2, vo.getUid());
			ps.setString(3, vo.getAddress1());
			ps.setString(4, vo.getAddress2());
			ps.setString(5, vo.getUphone());
			ps.setInt(6, vo.getPurSum());
			ps.execute();
		}catch(Exception e) {
			System.out.println("구매등록:" +e.toString());
		}
	}
}
