package imp.bean;

public class UserOrder {
	private String user;
	private int totalOrderNum;
	private double totalMoney;
	private String orderNums;
	public String getUser() {
		return user;
	}
	public void setUser(String user) {
		this.user = user;
	}
	public int getTotalOrderNum() {
		return totalOrderNum;
	}
	public void setTotalOrderNum(int totalOrderNum) {
		this.totalOrderNum = totalOrderNum;
	}
	public double getTotalMoney() {
		return totalMoney;
	}
	public void setTotalMoney(double totalMoney) {
		this.totalMoney = totalMoney;
	}
	public String getOrderNums() {
		return orderNums;
	}
	public void setOrderNums(String orderNums) {
		this.orderNums = orderNums;
	}
	

}
