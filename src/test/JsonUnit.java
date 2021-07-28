package test;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class JsonUnit {
	public static JSONObject getJson() throws JSONException {
		JSONObject json=new JSONObject();  
	    JSONArray jsonMembers = new JSONArray();  
	    JSONObject member1 = new JSONObject();  
	    member1.put("code", "1234");  
	   
	    jsonMembers.put(member1);  
	    json.put("jsons", jsonMembers);
	    return json;  
	  
		
	}
}
