package imp.unit;

import java.util.Random;

public class CreateRandomUser {
	
	private String numbers = "no";
	
	public CreateRandomUser() {
		Random rand = new Random();
		for(int i = 0;i < 9;i++){
			numbers += rand.nextInt(9) + 0;//
		}
	}
	public String getNumbers(){
		
		return numbers;
	}

}
