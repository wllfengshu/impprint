package imp.unit;

import java.util.Random;

public class CreateMsgValidation {
	
	private String numbers = "";
	
	public CreateMsgValidation() {
		Random rand = new Random();
		for(int i = 0;i < 4;i++){
			numbers += rand.nextInt(9) + 0;
		}
	}
	public String getNumbers(){
		
		return numbers;
	}

}
