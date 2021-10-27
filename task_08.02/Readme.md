```sh
- name: Install Kibana # имя плейбука
  hosts: elasticsearch # хост на котором будет выполнятся плейбук (задается в inventory/prod.yml)
  tasks:
    - name: Include vars
      include_vars:
        file: group_vars/kibana/vars.yml
    - name: Upload tar.gz Kibana from remote URL
      get_url:
        url: "https://artifacts.elastic.co/downloads/kibana/kibana-{{ kibana_version }}-linux-x86_64.tar.gz" # скачивание архива кибаны
        dest: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz" # в какую директорию скачается файл
        mode: 0755 # задаются права
        timeout: 60
        force: true
      register: get_kibana # вписать результат в переменную get_kibana
      until: get_kibana is succeeded # Повторять выполнение пока не получит код ответ:succeeded (не более трех раз)
      tags: kibana # тэг
    - name: Create directrory for Kibana
      file: # содается директория 
        state: directory
        path: "{{ kibana_home }}"
      tags: kibana
    - name: Extract Kibana in the installation directory
      become: true
      unarchive:
        copy: false
        src: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz" # где лежит архив
        dest: "{{ kibana_home }}" # куда распокавать
        extra_opts: [--strip-components=1] # доп опция архиватора
        creates: "{{ kibana_home }}/bin/kibana" # проверка
      tags:
        - skip_ansible_lint # тэг
        - kibana # тэг
    - name: Set environment Kibana 
      become: yes
      template: # копирует файл из src в des
        src: templates/kib.sh.j2
        dest: /etc/profile.d/kib.sh
      tags: kibana
```