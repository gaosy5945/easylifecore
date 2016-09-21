package com.amarsoft.app.base.businessobject;

import java.util.Comparator;


public class BusinessObjectComparator implements Comparator<BusinessObject> {

	public String attributeID;
	public String dataType;
	public int sortIndicator;
	public static final int  sortIndicator_asc = 1;
	public static final int  sortIndicator_desc = 2;
	
	public int compare(BusinessObject bo1,BusinessObject bo2){
		try {
			int result=0;
			Object o1=bo1.getObject(attributeID);
			Object o2=bo2.getObject(attributeID);
			if(o1==null){
				if(o2==null) result= 0;
				else result= -1;
			}
			else{
				if(o2==null) result= 1;
				else result= bo1.getString(attributeID).compareTo(bo2.getString(attributeID));
			}
			if(sortIndicator == sortIndicator_desc)
				return 0-result;
			else
				return result;
			
		} 
		catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
		
	}
}
