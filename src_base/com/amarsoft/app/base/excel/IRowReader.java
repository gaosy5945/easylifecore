package com.amarsoft.app.base.excel;

import java.util.List;

public interface IRowReader {
	 /**ҵ���߼�ʵ�ַ��� 
     * @param sheetIndex 
     * @param curRow 
     * @param rowlist 
     */  
    public  void getRows(int sheetIndex,int curRow, List<String> rowlist);  
}
