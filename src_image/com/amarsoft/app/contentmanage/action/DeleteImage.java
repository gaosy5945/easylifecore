package com.amarsoft.app.contentmanage.action;

import java.io.File;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteImage extends Bizlet {
	public Object  run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值		
		String sSerialNo = (String)this.getAttribute("SerialNo");
		if(sSerialNo == null) sSerialNo = "";
		String sSql = "";
		String sPath = "";
		ASResultSet rs = null;
		File file = null;
		String [] serialNo= sSerialNo.split("\\|");
		for(int i = 0;i<serialNo.length;i++){
			sSql = "select DocumentID from ECM_PAGE where SerialNo = '"+serialNo[i]+"'";
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next()){
				sPath = rs.getString("DocumentID");
				file = new File(sPath);
				// 路径为文件且不为空则进行删除
				if (file.isFile() && file.exists()) {
					file.delete();
				}
				Sqlca.executeSQL("delete from ECM_PAGE where SerialNo = '"+serialNo[i]+"'");
			}
			rs.close();
		}
		return "Sesses";
	}
}
