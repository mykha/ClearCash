#Использовать logos
Перем ЖурналЛогирования;
Процедура ВыполнитьОчистикуКэша(Параметры)
    Для Каждого ДиректорияОбработки Из Параметры.ДиректорииДляОбработки Цикл
        РабочийКаталог = Новый Файл(ДиректорияОбработки);
        фНичегоНеУдалено = Истина;
        Если НЕ РабочийКаталог.Существует() Тогда
            ЖурналЛогирования.Ошибка("!!! Директория " + ДиректорияОбработки + " не существует. Пропускаем.");
            Продолжить;
        КонецЕсли;
        ФайлыДляУдаления = НайтиФайлы(ДиректорияОбработки, "*", Ложь);
        Для Каждого ОбнаруженныйФайл Из ФайлыДляУдаления Цикл
            Если НЕ ОбнаруженныйФайл.ЭтоКаталог() Тогда
                Продолжить;
            КонецЕсли;
            ФлагПродолжить = Ложь;
            Для каждого элИсключение Из Параметры.Исключения Цикл
                Если СтрНайти(ОбнаруженныйФайл.Имя, элИсключение) > 0 Тогда
                    ЖурналЛогирования.Информация("----- Каталог """+ОбнаруженныйФайл.Имя+ """ пропущен. Совпало исключение """+элИсключение+""".");
                    ФлагПродолжить = Истина;
                КонецЕсли;
            КонецЦикла;
            Если ФлагПродолжить Тогда
                Продолжить;
            КонецЕсли;
            Попытка
                стрУдаляетсяКаталог =  ОбнаруженныйФайл.ПолноеИмя;
                ЖурналЛогирования.Информация("----- Удален каталог: " + стрУдаляетсяКаталог);
                УдалитьФайлы(ОбнаруженныйФайл.ПолноеИмя);
                фНичегоНеУдалено = Ложь;
            Исключение
                ЖурналЛогирования.Ошибка("!!! Не удалось удалить директорию: " + ОбнаруженныйФайл.ПолноеИмя);
            КонецПопытки;
        КонецЦикла;
        Если фНичегоНеУдалено Тогда
            ЖурналЛогирования.Информация("----- В папке """+ДиректорияОбработки+""" НЕ обнаружено каталогов для удаления");    
        КонецЕсли;
    КонецЦикла;
КонецПроцедуры
Функция ПодготовитьПараметры()
    СистемнаяИнформация = Новый СистемнаяИнформация;
    ДиректорияПрофиляПользователя = ПолучитьПеременнуюСреды("USERPROFILE");
    Результат = Новый Структура();
    Результат.Вставить("ДиректорииДляОбработки", Новый Массив);
    Результат.Вставить("Исключения", Новый Массив);
    Результат.ДиректорииДляОбработки.Добавить(ДиректорияПрофиляПользователя + "\AppData\Local\1C\1cv8");
    Результат.ДиректорииДляОбработки.Добавить(ДиректорияПрофиляПользователя + "\AppData\Roaming\1C\1cv8");
    Результат.Исключения.Добавить("ExtCompT");
    Возврат Результат;
КонецФункции
Параметры = ПодготовитьПараметры();
ЖурналЛогирования = Логирование.ПолучитьЛог("oscript.app.cleaner");
ВыполнитьОчистикуКэша(Параметры);