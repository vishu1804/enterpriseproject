@isTest
private class ContactUtilsTest {

    @isTest
    static void myUnitTest() {
        ContactUtil demo = new ContactUtil();
        System.assertEquals(demo.getAppVersion(), '1.0.0');
        // Uncomment the following line to cause a build failure
        // System.assert(false);
    }
}