package com.amarsoft.app.als.sys.widget;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.object.Item;
/**
 * 显示TreeTable
 * @author cjyu
 *
 */
public class TreeTabSelect {

	Item[] items;
	List<Item> tabLst=new ArrayList<Item>();
	String[][] sTabStrip;
	private String codeNo="";
	public TreeTabSelect(String codeNo,String sortNo) throws Exception{
		items=CodeManager.getItems(codeNo);
		this.codeNo=codeNo;
		init();
	}
	
	public void init(){
		String curSortNo="";
		for(Item item:items){
			if(curSortNo.equals("")){
				curSortNo=item.getSortNo();
				tabLst.add(item);
			}else if(!item.getSortNo().startsWith(curSortNo)){
				curSortNo=item.getSortNo();
				tabLst.add(item);
			}
		}
	}
	
	public String[][] getTabStrip(){
		int iRowNum=0;
		String[][] sTabStrip=new String[tabLst.size()][6];
		for(Item item:this.tabLst){
			sTabStrip[iRowNum][0]="true";
			sTabStrip[iRowNum][1]=item.getItemName();
			String url=item.getItemDescribe();
			if(getChildItem(item).size()>0){
					sTabStrip[iRowNum][2]="/AppMain/resources/widget/CodeTree.jsp";
					sTabStrip[iRowNum][3]="CodeNo="+codeNo+"&SortNo="+item.getSortNo();
			}else 	if(url.indexOf("?")>0){
				sTabStrip[iRowNum][2]=url.split("?")[0];
				sTabStrip[iRowNum][3]=url.split("?")[1];
			}else{
				sTabStrip[iRowNum][2]=url;
				sTabStrip[iRowNum][3]="";
			}
			sTabStrip[iRowNum][4]="";
			sTabStrip[iRowNum][5]="";
			iRowNum++;
		}
		return sTabStrip;
	}
	/**
	 * 获得Item下的子节点
	 * @param curItem
	 * @return
	 */
	public List<Item> getChildItem(Item curItem){
		String sortNo=curItem.getSortNo();
		List<Item> lst=new ArrayList<Item>();
		for(Item item:items){
			if(item.getSortNo().startsWith(sortNo) && !item.getSortNo().equals(sortNo)){
				lst.add(item);
			}
		}
		return lst;
	}
	/**
	 * {"true","","Button","保存","保存修改","saveRecord()","","","",""},//btn_icon_save 
	 * @param codeNo
	 * @param sortNo
	 * @return
	 * @throws Exception
	 */
	public static String[][] getButton(String codeNo,String sortNo) throws Exception{
		Item[] items=CodeManager.getItems(codeNo);
		List<Item> btnLst=new ArrayList<Item>();
		for(Item item:items){
			if(!item.getSortNo().startsWith(sortNo)) continue;
			String bankNo=item.getBankNo();
			if(bankNo.equalsIgnoreCase("button")){
				btnLst.add(item);
			}
		}
		String[][] sButtons=new String[btnLst.size()][10];
		for(int i=0;i<btnLst.size();i++){
			Item item=btnLst.get(i);
			sButtons[i][0]="true";
			sButtons[i][1]="All";
			sButtons[i][2]="Button";
			sButtons[i][3]=item.getItemName();
			sButtons[i][4]=item.getItemName();
			sButtons[i][5]=item.getItemDescribe();
			sButtons[i][6]="";
			sButtons[i][7]="";
			sButtons[i][8]="";
			sButtons[i][9]="";
		}
		return sButtons;
	}
}
