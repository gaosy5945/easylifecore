package com.amarsoft.app.awe.framecase.formatdoc.template01;

import java.lang.reflect.Field;

public class TestFormatDocHelp {

	public static void main(String[] args) {
		try {
			D001_00 one = new D001_00();
			one.initObject();
			
			Class clazz = Class.forName(one.getClass().getName());// ����а��Ļ�Ҫ����
			Field[] fields = clazz.getDeclaredFields();// ����Class���������� ˽�е�Ҳ���Ի��
			Field.setAccessible(fields, true);
			fields = clazz.getFields();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
