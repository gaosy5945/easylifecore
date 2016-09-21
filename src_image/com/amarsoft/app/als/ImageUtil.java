package com.amarsoft.app.als;

import com.amarsoft.awe.util.Transaction;


public class ImageUtil {
	private String startWithId ;
	
	public String GetNewTypeNo( Transaction sqlca ) throws Exception{
		String sRes = "", sFilter = "";
		sFilter = "'"+ startWithId + "%'";
		String sMax = sqlca.getString( "Select Max(TypeNo) From ECM_IMAGE_TYPE Where TypeNo Like "+sFilter );
		if( sMax != null && sMax.length() != 0 ){
			sRes = String.valueOf( Integer.parseInt( sMax ) + 1 );
		}
		return sRes;
	}

	public String getStartWithId() {
		return startWithId;
	}
	public void setStartWithId(String startWithId) {
		this.startWithId = startWithId;
	}
}
