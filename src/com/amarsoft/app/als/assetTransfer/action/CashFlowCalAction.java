/**
 * 
 */
package com.amarsoft.app.als.assetTransfer.action;

import java.util.ArrayList;
import java.util.List;

/**
 * 描述：现金流预测相关处理
 * @author xyli
 * @2014-5-7
 */
public class CashFlowCalAction {
	
	public List<List<String>> getCashFlowCalDatas(String serialNos){
		
		List<List<String>> allList = new ArrayList<List<String>>();
		//测试数据
		List<String> list1 = new ArrayList<String>();
		list1.add("04月");
		list1.add("12");
		list1.add("23");
		list1.add("3");
		list1.add("4");
		list1.add("546");
		list1.add("67");
		allList.add(list1);
		
		List<String> list2 = new ArrayList<String>();
		list2.add("05月");
		list2.add("45");
		list2.add("5");
		list2.add("7");
		list2.add("676");
		list2.add("90");
		list2.add("343");
		allList.add(list2);
		
		List<String> list3 = new ArrayList<String>();
		list3.add("合计");
		list3.add("121");
		list3.add("2222");
		list3.add("56");
		list3.add("5656");
		list3.add("4");
		list3.add("8998");
		allList.add(list3);
		
		return allList;
	}
}
