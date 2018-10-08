class CollectiveMind {
  
  ArrayList<Sem> list; 
  
  CollectiveMind(){
    list = new ArrayList();
  } 

  void subscribe(Sem sem){
    //Add reference to new Sem
    list.add(sem);
  }
  
  void send(String str){
   for(Sem sem: list){
     sem.receive(str);
   }
  
  }
}
